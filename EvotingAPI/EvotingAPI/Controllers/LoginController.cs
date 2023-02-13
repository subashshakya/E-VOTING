using BCrypt.Net;
using Dapper;
using EvotingAPI.Model;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace EvotingAPI.Controllers
{
    [ApiController]
    [Route("api/[Controller]")]
    public class LoginController : Controller
    {
        private readonly IDapperService _dapperService;
        private readonly IConfiguration _configuration;
        public LoginController(IDapperService dapperService, IConfiguration configuration)
        {
            _dapperService= dapperService;
            _configuration= configuration;
        }
        [HttpPost]
        [Route("LoginUser")]
        [AllowAnonymous]
        public IActionResult Login([FromBody] LoginModel model)
        {
            string sql = @"select * from Tbl_user where UserName=@UserName";
            var param = _dapperService.AddParam(model);
            var result = _dapperService.Query<UserModel>(sql, param).FirstOrDefault();
            if(result==null)
            {
                return NotFound("USerName not found");
            }
            else
            {
                if (!BCrypt.Net.BCrypt.Verify(model.Password, result.Password))
                {
                    return Ok("Wrong Password");
                }
                var token = Createtoken(result);
                return Ok(token);
            }
            
        }
        [HttpPost]
        [Route("RegisterUser")]
        [Authorize(Roles ="SuperAdmin")]
        public IActionResult Regiser([FromBody] UserModel model)
        {
            string sql = @"Select Username from Tbl_user where Username=@Username";
            var param = new DynamicParameters();
            param.Add("@UserName", model.UserName);
            var checkifUserNameExists = _dapperService.Query<UserModel>(sql, param).FirstOrDefault();
            if (checkifUserNameExists!= null)
            {
                return Ok("UserName already exists");
            }
            string insertsql = @"insert into Tbl_user values(@UserName,@Password,@email,@Roles)";
            model.Password = BCrypt.Net.BCrypt.HashPassword(model.Password);
            var parameter = _dapperService.AddParam(model);
            var result = _dapperService.Execute(insertsql, parameter);
            if (result > 0)
                return Ok("Admin Created");
            return Ok("Admin not created");
        }
        private string Createtoken(UserModel result)
        {
            List<Claim> claims = new List<Claim>()
            {
                new Claim(ClaimTypes.Name,result.UserName),
                new Claim(ClaimTypes.Role,result.Roles)
            };
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(
                                                _configuration.GetSection("AppSettings:Token").Value!));

            var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha512Signature);
            var token = new JwtSecurityToken(
                    claims: claims,
                    expires: DateTime.Now.AddDays(1),
                    signingCredentials: credentials
                   );
            var jwtToken = new JwtSecurityTokenHandler().WriteToken(token);
            return (jwtToken);
        }
    }
}
