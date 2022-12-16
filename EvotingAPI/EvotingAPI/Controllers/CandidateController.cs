using EvotingAPI.Model;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System.Configuration;
using System.Data.SqlClient;

namespace EvotingAPI.Controllers
{
    [Route("api/[Controller]")]
    [ApiController]
    public class CandidateController : Controller
    {
        private readonly string _connstring;
        private readonly ILogger<CandidateController> _logger;
        private readonly IDapperService _dapperService;
        public CandidateController(IConfiguration configuration, ILogger<CandidateController> logger,IDapperService dapperService)
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
        public  bool CreateCandidate([FromBody] CandidateModel model)
        {
            string sql = @"Insert into Candidate values(@CandidateName,@CandidatePhoto,@CandidatePartyName,@CandidatePartySymbol)";
            _logger.LogInformation("Adding candidate");
            var parameters = _dapperService.AddParam(model);
            var affectedRows = _dapperService.Execute(sql,parameters);
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
            if (affectedRows > 0)
                return true;
            else
                return false;

        }
        [HttpPost]
        [Route("Delete")]
        public bool DeleteCandidate([FromBody] int? id)
        {
            string sql = @"Delete From Candidate where CandidateId =@id";
            _logger.LogInformation("Deleteing Candidate");
            var parameter = _dapperService.AddParam(id);
            var affectedRows = _dapperService.Execute(sql,parameter);
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
            var affectedRows = _dapperService.Execute(sql,parameters);
            _logger.LogInformation("Updated");
            if (affectedRows > 0)
                return true;
            return false;
        }

    }
}
