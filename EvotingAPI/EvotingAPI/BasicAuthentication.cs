using Dapper;
using EvotingAPI;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using System;
using System.Net;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Security.Principal;
using System.Text;
using System.Text.Encodings.Web;
using System.Threading.Tasks;
//using System.Web.Http.Controllers;
//using System.Web.Http.Filters;

namespace APITest
{
    #region old
    //public class BasicAuthenticationAttribute : AuthorizationFilterAttribute
    //{
    //    public override void OnAuthorization(HttpActionContext actionContext)
    //    {
    //        if (actionContext.Request.Headers.Authorization == null)
    //        {
    //            actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.Unauthorized);
    //            try
    //            {
    //                var authHeader = actionContext.Request.Headers.Authorization;
    //                var credentialBytes = Convert.FromBase64String(authHeader.Parameter);
    //                var credentials = Encoding.UTF8.GetString(credentialBytes).Split(new[] { ':' }, 2);
    //                var username = credentials[0];
    //                var password = credentials[1];

    //                //Dapper
    //                //user = await DTO.Authenticate(username, password);
    //                if (Authenticate(username, password))
    //                {
    //                    Thread.CurrentPrincipal = new GenericPrincipal(new GenericIdentity(username), null);
    //                }
    //                else
    //                {
    //                    actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.Unauthorized);
    //                }
    //            }
    //            catch
    //            {
    //                actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.BadRequest);
    //            }

    //        }

    //    }

    //    private bool Authenticate(string username, string password)
    //    {
    //        return true;
    //    }
    //}
    #endregion
    public class BasicAuthenticationHandler : AuthenticationHandler<AuthenticationSchemeOptions>
    {
        private readonly IDapperService _dapperService;
        public BasicAuthenticationHandler(IDapperService dapperService,
            IOptionsMonitor<AuthenticationSchemeOptions> options,
            ILoggerFactory logger,
            UrlEncoder encoder,
            ISystemClock clock)
            : base(options, logger, encoder, clock)
        {
            _dapperService = dapperService;
        }


        protected override async Task<AuthenticateResult> HandleAuthenticateAsync()
        {
            if (!Request.Headers.ContainsKey("Authorization"))
                return AuthenticateResult.Fail("Missing Authorization Header");
            //User user = null;
            try
            {
                var authHeader = AuthenticationHeaderValue.Parse(Request.Headers["Authorization"]);
                //var biometric = AuthenticationHeaderValue.Parse(Request.Headers["Biometric"]).ToString();
                var credentialBytes = Convert.FromBase64String(authHeader.Parameter);
                var credentials = Encoding.UTF8.GetString(credentialBytes).Split(new[] { ':' }, 2);
                var username = credentials[0];
                var password = credentials[1];
                var user =  Authenticate(username, password,"sdooo");
                if (user.CompareTo("Does not Exists")==0)
                    return AuthenticateResult.Fail("Invalid Username or Password");
                var claims = new Claim[] {
                new Claim(ClaimTypes.Name, username),
                new Claim(ClaimTypes.Role,user),
            };
                var identity = new ClaimsIdentity(claims,Scheme.Name);
                var principal = new ClaimsPrincipal(identity);
                var ticket = new AuthenticationTicket(principal, Scheme.Name);
                return AuthenticateResult.Success(ticket);
            }
            catch
            {
                return AuthenticateResult.Fail("Invalid Authorization Header");
            }
            
        }
         
        private string Authenticate(string username, string password,string biometric)
        {
            //check in db
            string sql = @"Select Roles from Administration where username = @username and password = @password";
            var param = new DynamicParameters();
            param.Add("@username", username);
            param.Add("@password", password);
            var roles = _dapperService.Query<string>(sql, param).FirstOrDefault();
            if (roles==null)
            {
                return "Does not Exists";
            }
            else
                return roles;
        }
    }
    public class User
    {
        public string Username { get; set; }
        public string  Password { get; set; }
    }
}
