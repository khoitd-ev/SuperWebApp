using AspNetCoreHero.ToastNotification;
using BlueSports.Data;
using BlueSports.Services;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.EntityFrameworkCore;
using System.Text.Encodings.Web;
using System.Text.Unicode;

var builder = WebApplication.CreateBuilder(args);

// Cấu hình DbContext
// cấu hình bằng sqlserver
//builder.Services.AddDbContext<ApplicationDbContext>(options =>
//    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

//// cấu hình bằng mysql
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseMySQL(builder.Configuration.GetConnectionString("DefaultConnection")));

// Bật mã hóa HTML (để hỗ trợ Unicode)
builder.Services.AddSingleton<HtmlEncoder>(
    HtmlEncoder.Create(allowedRanges: new[] { UnicodeRanges.All }));

// Cấu hình Session
builder.Services.AddDistributedMemoryCache();
builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromHours(1);
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
});

// Cấu hình Authentication với Cookie
builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
    .AddCookie(options =>
    {
        options.Cookie.Name = "UserLoginCookie";
        options.ExpireTimeSpan = TimeSpan.FromDays(1);
        options.LoginPath = "/Log-in"; // Trang đăng nhập nếu chưa xác thực
        options.AccessDeniedPath = "/not-found.html"; // Trang lỗi truy cập bị từ chối
    });

// Đăng ký dịch vụ MoMoPaymentService
builder.Services.AddHttpClient<MoMoPaymentService>();

// Bật Runtime Compilation cho Razor View
builder.Services.AddControllersWithViews().AddRazorRuntimeCompilation();

// Cấu hình Toast Notification
builder.Services.AddNotyf(config =>
{
    config.DurationInSeconds = 5;
    config.IsDismissable = true;
    config.Position = NotyfPosition.TopRight;
});

// Build Application
var app = builder.Build();

// Cấu hình Middleware và Request Pipeline

// Xử lý lỗi không phải trong môi trường Development
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error"); // Chuyển hướng lỗi tới Home/Error
    app.UseHsts(); // Kích hoạt HTTP Strict Transport Security
}

app.UseHttpsRedirection(); // Tự động chuyển hướng HTTP sang HTTPS
app.UseStaticFiles(); // Cho phép truy cập các tệp tĩnh như CSS, JS

app.UseSession(); // Kích hoạt Session Middleware
app.UseCookiePolicy(); // Kích hoạt Cookie Policy
app.UseRouting(); // Định tuyến yêu cầu HTTP

app.UseAuthentication(); // Kích hoạt Middleware xác thực
app.UseAuthorization(); // Kích hoạt Middleware phân quyền

// Cấu hình xử lý lỗi toàn cục
app.UseExceptionHandler("/Home/Error"); // Điều hướng đến trang lỗi chung
app.UseStatusCodePagesWithReExecute("/Home/Error", "?code={0}"); // Xử lý lỗi trạng thái HTTP

// Định tuyến mặc định
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

// Chạy ứng dụng
app.Run();
