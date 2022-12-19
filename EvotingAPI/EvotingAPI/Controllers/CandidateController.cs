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
        public IActionResult GetAllDetails()
        {

            _logger.LogInformation("fetching data");
            string sql = @"Select * from Candidate";
            var list = _dapperService.Query<CandidateModel>(sql).ToList();
            _logger.LogInformation("Fetching complete");
            foreach(var item in list)
            {
                var getCandidatePhoto = encodeToBase64(item.candidateFirstName, item.candidateLastName, "CandidatePhoto");
                var getCandidatePartySymbol = encodeToBase64(item.candidateFirstName, item.candidateLastName, "CandidatePartysymbol");
                item.candidatePhoto = getCandidatePhoto;
                item.candidatePartySymbol = getCandidatePartySymbol;
            }
            #region oldcode
            //SqlConnection con = new SqlConnection(_connstring);
            //SqlCommand cmd = new SqlCommand(sql, con);
            //con.Open();
            //SqlDataReader reader = cmd.ExecuteReader();
            //List<CandidateModel> list = new List<CandidateModel>();
            //while(reader.Read())
            //{
            //    CandidateModel model = new CandidateModel();
            //    model.candidateName = reader["CandidateName"].ToString();
            //    model.candidatePhoto = reader["CandidatePhoto"].ToString();
            //    model.candidatePartyName = reader["CandidatePartyName"].ToString();
            //    model.candidatePartySymbol = reader["CandidatePartySymbol"].ToString();
            //    list.Add(model);
            //}
            //con.Close();
            #endregion
            return Ok(list);
        }
        [HttpPost]
        [Route("AddCandidate")]
        public bool CreateCandidate([FromBody] CandidateModel model)
        {
            string sql = @"Insert into Candidate values(@CandidateFirstName,@CandidateLastName,@CandidatePartyName)";
            _logger.LogInformation("Adding candidate");
            var parameters = _dapperService.AddParam(model);
            var uploadCandidatePhoto = DecodeBase64String(model.candidatePhoto,"CandidatePhoto",model.candidateFirstName,model.candidateLastName);
            var uploadCandidatePartySymbol = DecodeBase64String(model.candidatePartySymbol,"CandidatePartySymbol", model.candidateFirstName, model.candidateLastName); 
            var affectedRows = _dapperService.Execute(sql, parameters);
            _logger.LogInformation("Candidate added");
            #region oldcode
            //SqlConnection con = new SqlConnection(_connstring);
            //SqlCommand cmd = new SqlCommand(sql, con);
            //cmd.Parameters.AddWithValue("@CandidateName", model.candidateName);
            //cmd.Parameters.AddWithValue("@CandidatePhoto", model.candidatePhoto);
            //cmd.Parameters.AddWithValue("@CandidatePartyName", model.candidatePartyName);
            //cmd.Parameters.AddWithValue("@CandidatePartySymbol", model.candidatePartySymbol);
            //con.Open();
            //int affectedRows = cmd.ExecuteNonQuery();
            //con.Close();
            #endregion
            if (affectedRows <= 0 && !uploadCandidatePhoto && !uploadCandidatePartySymbol)
                return false;
            else
                return true;

        }
        [HttpPost]
        [Route("Delete")]
        public bool DeleteCandidate([FromBody] int? id)
        {
            string sql = @"Delete From Candidate where CandidateId =@id";
            _logger.LogInformation("Deleteing Candidate");
            var parameter = _dapperService.AddParam(id);
            var affectedRows = _dapperService.Execute(sql, parameter);
            _logger.LogInformation("Deleted");
            if (affectedRows > 0)
                return true;
            return false;
        }
        [HttpPost]
        [Route("UpdateInfo")]
        public bool UpdateCandidateInfo([FromBody] CandidateModel model)
        {
            string sql = @"Update Candidate set CandidateName=@candidateName , CandidatePhoto=@candidatePhoto, CandidatePartyName=@CandidatePartyName , CandidatePartySymbol=@candidatePartysymbol where CandidateId = @id";
            _logger.LogInformation("Updating candidate");
            var parameters = _dapperService.AddParam(model);
            parameters.Add("@id", model.candidateId);
            var affectedRows = _dapperService.Execute(sql, parameters);
            _logger.LogInformation("Updated");
            if (affectedRows > 0)
                return true;
            return false;
        }
        private bool DecodeBase64String(string encodedString, string FolderName,string FirstName , string LastName)
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
        private string encodeToBase64(string FirstName , string LastName , string FolderName)
        {
            var fileName = FirstName + LastName + ".jpg";
            string encodedImage = "";
            var path = Path.Combine(Directory.GetCurrentDirectory(), FolderName, fileName);
            byte[] filebytes = System.IO.File.ReadAllBytes(path);
            encodedImage = Convert.ToBase64String(filebytes);
            return encodedImage;
        }

    }
}
