using Microsoft.AspNetCore.Mvc;

namespace BlueSports.Controllers
{
    public class HomeController : Controller
    {
        [Route("")]
        [Route("Home")]
        [Route("Home/Index")]
        public IActionResult Index()
        {
            return View();
        }

        // Trang lỗi
        [Route("Home/Error")]
        public IActionResult Error(string code = null)
        {
            if (!string.IsNullOrEmpty(code))
            {
                ViewBag.ErrorCode = code; // Mã trạng thái HTTP, ví dụ: 404, 500
            }
            else
            {
                ViewBag.ErrorCode = "Unknown";
            }

            ViewBag.ErrorMessage = "An error occurred while processing your request.";
            return View();
        }
    }

}
