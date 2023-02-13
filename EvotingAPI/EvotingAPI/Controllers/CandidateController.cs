using EvotingAPI.Model;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System.Configuration;
using System.Data.SqlClient;
using System.Reflection;
using System.IO;
using static System.Net.WebRequestMethods;
using System.Text;
using System.Drawing.Imaging;
using System.Drawing;
using System.Reflection.Metadata;
using Dapper;
using System.Net.Http.Headers;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;

namespace EvotingAPI.Controllers
{
    [Route("api/[Controller]")]
    [ApiController]

    public class CandidateController : Controller
    {
        private readonly string _connstring;
        private readonly ILogger<CandidateController> _logger;
        private readonly IDapperService _dapperService;
        public CandidateController(IConfiguration configuration, ILogger<CandidateController> logger, IDapperService dapperService)
        {
            _connstring = configuration.GetConnectionString("DbString");
            _logger = logger;
            _dapperService = dapperService;
        }
        [HttpGet]
        [Route("GetAllDetails")]
        [Authorize(Roles ="SuperAdmin,Admin,Voter")]
        public IActionResult GetAllDetails()
        {
            var user = HttpContext.User;
            var claimsIdentity = user.Identity as ClaimsIdentity;
            var idclaim = claimsIdentity.FindFirst(ClaimTypes.Role);
            var role = idclaim.Value;
            _logger.LogInformation("fetching data by : {0}",role);
            string sql = @"Select * from Candidate";
            var list = _dapperService.Query<CandidateModel>(sql).ToList();
            _logger.LogInformation("Fetching complete");
<<<<<<< HEAD
            //foreach(var item in list)
            //{
            //    var getCandidatePhoto = encodeToBase64(item.candidateFirstName, item.candidateLastName, "CandidatePhoto");
            //    var getCandidatePartySymbol = encodeToBase64(item.candidateFirstName, item.candidateLastName, "CandidatePartysymbol");
            //    //item.candidatePhoto = "ok";
            //    item.candidatePhoto = getCandidatePhoto;
            //    //item.candidatePartySymbol = "ok";
            //    item.candidatePartySymbol = getCandidatePartySymbol;
            //}
            
            
=======
            foreach (var item in list)
            {
                var getCandidatePhoto = encodeToBase64(item.candidateFirstName, item.candidateLastName, "CandidatePhoto");
                var getCandidatePartySymbol = encodeToBase64(item.candidateFirstName, item.candidateLastName, "CandidatePartysymbol");
                //item.candidatePhoto = "ok";
                item.candidatePhoto = getCandidatePhoto;
                //item.candidatePartySymbol = "ok";
                item.candidatePartySymbol = getCandidatePartySymbol;
            }
<<<<<<< HEAD
=======


>>>>>>> 7a8b02d641746b1b2d9b12f74e64034fc76750de
>>>>>>> 393303cd42ed34ec9b382ea37b9ed0fc1783f2fa
            return Ok(list);
        }
        [HttpPost]
        [Route("AddCandidate")]
        [Authorize(Roles ="SuperAdmin")]
        public bool CreateCandidate([FromBody] CandidateModel model)
        {
            Image image = null;
            string sql = @"Insert into Candidate values(
                                                        @CandidateFirstName,
                                                        @CandidateLastName,
                                                        @CandidatePartyName,
                                                        @NominatedYear,
                                                        @RomanizedCandidateFirstName,
                                                        @RomanizedCandidateLastName,
                                                        @RomanizedCandidatePartyName)";
            _logger.LogInformation("Adding candidate");
            var parameters = _dapperService.AddParam(model);
            byte[] decodedBytes = Convert.FromBase64String(model.candidatePhoto);
            var uploadCandidatePhoto = DecodeBase64String(model.candidatePhoto, "CandidatePhoto", model.candidateFirstName, model.candidateLastName);
            var uploadCandidatePartySymbol = DecodeBase64String(model.candidatePartySymbol, "CandidatePartySymbol", model.candidateFirstName, model.candidateLastName);
            var affectedRows = _dapperService.Execute(sql, parameters);
            _logger.LogInformation("Candidate added");

            if (affectedRows <= 0 && !uploadCandidatePhoto && !uploadCandidatePartySymbol)
                return false;
            else
                return true;

        }
        [HttpPost]
        [Route("Delete")]
        [Authorize(Roles ="SuperAdmin")]
        public bool DeleteCandidate([FromBody] CandidateIdmodel model)
        {
            //var model = getCandidateById(id);
            string sql = @"Delete From Candidate where CandidateId =@CandidateId";
            _logger.LogInformation("Deleteing Candidate");
            var parameter = _dapperService.AddParam(model);
            var affectedRows = _dapperService.Execute(sql, parameter);
            //var deleteCandidatePhoto = deleteCandidateImages("CandidatePhoto", model.candidateFirstName, model.candidateLastName);
            //var deleteCandidatePartySymbol = deleteCandidateImages("CandidatePartySymbol", model.candidateFirstName, model.candidateLastName);
            _logger.LogInformation("Deleted");
            if (affectedRows > 0)
                return true;
            return false;
        }
        [HttpPost]
        [Route("UpdateInfo")]
        [Authorize(Roles ="SuperAdmin")]
        public bool UpdateCandidateInfo([FromBody] CandidateModel model)
        {
            string sql = @"Update Candidate set CandidateName=@candidateName , CandidatePhoto=@candidatePhoto, CandidatePartyName=@CandidatePartyName , CandidatePartySymbol=@candidatePartysymbol,year=@year where CandidateId = @id";
            _logger.LogInformation("Updating candidate");
            var parameters = _dapperService.AddParam(model);
            parameters.Add("@id", model.candidateId);
            var affectedRows = _dapperService.Execute(sql, parameters);
            _logger.LogInformation("Updated");
            if (affectedRows > 0)
                return true;
            return false;
        }
        private bool DecodeBase64String(string encodedString, string FolderName, string FirstName, string LastName)
        {
            string FileName = FirstName + LastName + ".jpg";
            byte[] decodedBytes = Convert.FromBase64String(encodedString);

            var path = Path.Combine(Directory.GetCurrentDirectory(), FolderName, FileName);
            using (MemoryStream ms = new MemoryStream(decodedBytes))
            {
                Image image = Image.FromStream(ms);
                image.Save(path, ImageFormat.Jpeg);
            }
            //System.IO.File.WriteAllBytes(path,decodedBytes);
            return true;
        }
        private string encodeToBase64(string FirstName, string LastName, string FolderName)
        {
            var fileName = FirstName + LastName + ".jpg";
            string encodedImage = "";
            var path = Path.Combine(Directory.GetCurrentDirectory(), FolderName, fileName);
            byte[] filebytes = System.IO.File.ReadAllBytes(path);
            encodedImage = Convert.ToBase64String(filebytes);
            return encodedImage;
        }
        //private CandidateModel getCandidateById(int? id)
        //{
        //    string sql = @"Select CandidateFirstName,CandidateLastName from Candidate where CandidateId=@Id";
        //    var parameters = _dapperService.AddParam(id);
        //    var model = _dapperService.Query<CandidateModel>(sql, parameters).FirstOrDefault();
        //    return model;
        //}

        //private bool deleteCandidateImages(string FolderName , string FirstName, string LastName)
        //{
        //    var FileName = FirstName + LastName + ".jpg";
        //    var path = Path.Combine(Directory.GetCurrentDirectory(),FolderName, FileName);
        //    try
        //    {
        //        System.IO.File.Delete(path);
        //        return true;
        //    }
        //    catch
        //    {
        //        return false;
        //    }

        //}

    }
}
