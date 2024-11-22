﻿using BlueSports.Data;
using BlueSports.Models;
using BlueSports.HandleAdmin.ModelViews;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using AspNetCoreHero.ToastNotification.Abstractions;
using System.Collections.Generic;
using System.Linq;
using System;
using BlueSports.HandleAdmin.Extension;
using Microsoft.EntityFrameworkCore;
using BlueSports.Services;
using System.Text.Json;

namespace BlueSports.Controllers
{
    public class CheckoutController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly INotyfService _notyfService;

        // KHOITD-EV SECTION
        // ** BEGIN **
        private readonly MoMoPaymentService _moMoPaymentService;

        public CheckoutController(ApplicationDbContext context, INotyfService notyfService, MoMoPaymentService moMoPaymentService)
        {
            _context = context;
            _notyfService = notyfService;
            _moMoPaymentService = moMoPaymentService;
        }
        // ** END **


        private List<CartItem> GetCartItems()
        {
            var cartItems = HttpContext.Session.Get<List<CartItem>>("GioHang") ?? new List<CartItem>();
            return cartItems;
        }

        private void UpdateCustomerAddress(int userId, string address)
        {
            User? customer = _context.Users.SingleOrDefault(x => x.UserID == Convert.ToInt32(userId));
            if (customer != null)
            {
                customer.ShippingAddress = address;
                _context.Update(customer);
                _context.SaveChanges();
            }
        }

        [Route("checkout", Name = "Checkout")]
        public IActionResult Index(string returnUrl = null)
        {
            var cart = GetCartItems();
            var userId = HttpContext.Session.GetString("UserID");
            var model = new MuaHangVM
            {
                Carts = cart // Gán giỏ hàng vào model
            };

            if (userId != null)
            {
                var customer = _context.Users.AsNoTracking().SingleOrDefault(x => x.UserID == Convert.ToInt32(userId));
                if (customer != null)
                {
                    model.CustomerId = customer.UserID;
                    model.FullName = customer.UserName;
                    model.Email = customer.Email;
                    model.Phone = customer.PhoneNumber;
                    model.Address = customer.ShippingAddress;
                }
            }

            return View(model);
        }



        [HttpPost]
        [Route("checkout", Name = "Checkout")]
        public async Task<IActionResult> Index(MuaHangVM model)
        {
            var cart = GetCartItems();
            var userId = HttpContext.Session.GetString("UserID");

            if (userId != null)
            {
                UpdateCustomerAddress(Convert.ToInt32(userId), model.Address);
            }

            try
            {
                if (!ModelState.IsValid)
                {
                    ViewBag.GioHang = cart;
                }




                long totalAmount = (long)Math.Round(cart.Sum(item => item.TotalMoney), MidpointRounding.AwayFromZero);
                
                // Tạo orderdetails và redirect url
                var orderId = CreateOrder(model, cart);
                HttpContext.Session.Remove("GioHang");
                var redirectUrl = Url.Action("Success", "Checkout", new { orderId = orderId }, Request.Scheme);

                // NHAN NGUYEN SECTION
                // ** BEGIN **
                var request = new MomoPaymentRequest
                {
                    OrderInfo = "pay with MoMo",
                    Amount = totalAmount, // Need to greater than 10.000 VND and below 50.000.000 VND
                    IpnUrl = "https://webhook.site/b3088a6a-2d17-4f8d-a383-71389a6c600b",
                    RedirectUrl = redirectUrl // TODO: Change Order ID After Creating Order
                };

                var response = await _moMoPaymentService.CreatePaymentRequest(request);

                // Check if the request was successful
                if (response.TryGetValue("resultCode", out var resultCodeElement) && resultCodeElement is JsonElement resultCodeJson && resultCodeJson.GetInt32() == 0)
                {
                    // Redirect to MoMo payment page using `payUrl`
                    if (response.TryGetValue("payUrl", out var payUrlElement) && payUrlElement is JsonElement payUrlJson)
                    {
                        var payUrl = payUrlJson.GetString();
                        return Redirect(payUrl);
                    }
                }
                // ** END **

                Console.WriteLine("Error: " + response["message"]);
                _notyfService.Error("Payment initialization failed.");
                ViewBag.GioHang = cart;
                return View(model);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
                ViewBag.GioHang = cart;
                return View(model);
            }
        }
        public enum OrderStatus
        {
            Processing = 1,
            Shipped = 2,
            Delivered = 3
        }

        // Trả về int thay vì IActionResult để lấy orderId
        private int CreateOrder(MuaHangVM model, List<CartItem> cart)
        {
            var order = new Order
            {
                UserID = model.CustomerId,
                ShippingAddress = model.Address,
                OrderDate = DateTime.Now,
                ShippingStatus = (int)OrderStatus.Processing,  // Gán giá trị số nguyên cho trạng thái
                TotalAmount = cart.Sum(x => x.TotalMoney),
                PaymentMethod = "COD",
                EstimatedDeliveryDate = DateTime.Now,
                DeliveryDate = DateTime.Now.AddDays(3),
                TrackingNumber = "",
            };

            try
            {
                _context.Add(order);
                _context.SaveChanges();

                foreach (var item in cart)
                {
                    var orderDetail = new OrderDetail
                    {
                        OrderID = order.OrderID,
                        ProductID = item.product.ProductID,
                        Quantity = item.amount,
                        Price = item.product.Price
                    };
                    _context.Add(orderDetail);
                }

                _context.SaveChanges();

                // Trả về orderId sau khi tạo đơn hàng thành công
                return order.OrderID;
            }
            catch (DbUpdateException ex)
            {
                Console.WriteLine("Error occurred while saving changes: " + ex.InnerException?.Message);
                throw;
            }
        }

        // KHOITD-EV SECTION
        // ** BEGIN **
        [HttpGet]
        [Route("checkout/success", Name = "PaymentSuccess")]
        // ** END **
        public IActionResult Success(int orderId)
        {
            Console.WriteLine($"Received orderId: {orderId}"); // Log để kiểm tra orderId

            var order = _context.Orders
                .Include(x => x.User)
                .AsNoTracking()
                .FirstOrDefault(x => x.OrderID == orderId);

            if (order == null)
            {
                _notyfService.Error("Order not found.");
                return RedirectToAction("Index", "Home"); // Điều hướng nếu không tìm thấy đơn hàng
            }

            var model = new MuaHangSuccessVM
            {
                DonHangID = order.OrderID,
                FullName = order.User?.UserName ?? "N/A",
                Phone = order.User?.PhoneNumber ?? "N/A",
                Address = order.ShippingAddress
            };

            return View(model);
        }



    }
}
