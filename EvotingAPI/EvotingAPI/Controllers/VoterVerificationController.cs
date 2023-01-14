using Dapper;
using EvotingAPI.Model;
using Microsoft.AspNetCore.Mvc;
using Neurotec.SmartCards;

namespace EvotingAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class VoterVerificationController : Controller
    {
        private readonly IDapperService _dapperService;
        private readonly ILogger<VoterVerificationController> _logger;
        public VoterVerificationController(IDapperService dapperService, ILogger<VoterVerificationController> logger)
        {
            _dapperService=dapperService;
            _logger = logger;
        }
        [HttpPost]
        [Route("VerifyVoterId")]
        public IActionResult VerifyId([FromBody] VoterModel model)
        {
            string sql = @"Select VoterId,CitizenshipId from VoterList where VoterId=@VoterId And CitizenshipId=@CitizenshipId";
            DynamicParameters param = new DynamicParameters();
            param.Add("@Voterid", model.VoterId);
            param.Add("@CitizenshipId", model.CitizenshipId);
            var result = _dapperService.Query<VoterModel>(sql, param).ToList();
            if(result.Count==1)
            {
                return Ok("Verified");
            }    
            return BadRequest("Not Verified");
        }

    }
}
