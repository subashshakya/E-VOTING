using Dapper;
using EvotingAPI.Model;
using Microsoft.AspNetCore.Mvc;
using Neurotec.SmartCards;

namespace EvotingAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class VoterController : Controller
    {
        private readonly IDapperService _dapperService;
        private readonly ILogger<VoterController> _logger;
        public VoterController(IDapperService dapperService, ILogger<VoterController> logger)
        {
            _dapperService=dapperService;
            _logger = logger;
        }
        [HttpPost]
        [Route("VerifyVoterId")]
        public IActionResult VerifyId([FromBody] VoterVerificationModel model)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }
                string sql = @"Select VoterId,CitizenshipId from VoterList where VoterId=@VoterId And CitizenshipId=@CitizenshipId";
                var param = _dapperService.AddParam(model);
                _logger.LogInformation("Checking Voter exists or not");
                var result = _dapperService.Query<VoterVerificationModel>(sql, param).ToList();
                if (result.Count == 1)
                {
                    _logger.LogInformation("voter exists");
                    return Ok("Verified");
                }
                _logger.LogInformation("voter does not exists");
                return BadRequest("Not Verified");
            }
            catch(Exception e)
            {
                _logger.LogInformation("Exception:{0}",e);
                return BadRequest("Exception occured");
            }
        }

        [HttpPost]
        [Route("RegisterVoter")]
        public IActionResult RegisterVoter([FromBody] VoterRegistrationModel model)
        {
            string sql = @"Insert into Voterlist values(@VoterId,
                                                @CitizenShipId,
                                                @FirstName,
                                                @MiddleName,
                                                @LastName,
                                                @DateOfBirth,@Gender,@Address,@State,@District,@WardNo,@Municipality)";
            var param = _dapperService.AddParam(model);
            var result = _dapperService.Execute(sql, param);
            if (result > 0)
                return Ok("Voter Added");
            return Ok("Unsuccessfull");
        }

    }
}
