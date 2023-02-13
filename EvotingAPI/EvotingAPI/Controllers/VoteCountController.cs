using Dapper;
using EvotingAPI.Model;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace EvotingAPI.Controllers
{

    [ApiController]
    [Route("api/[Controller]")]
    public class VoteCountController : Controller
    {
        private readonly IDapperService _dapperService;
        private readonly ILogger<VoteCountController> _logger;
        public VoteCountController(IDapperService dapperService, ILogger<VoteCountController> logger)
        {
            _dapperService=dapperService;
            _logger=logger;
        }
        [HttpPost]
        [Route("AddVote")]
        [Authorize(Roles ="Voter")]
        public IActionResult AddVote([FromBody] VoteCountModel model)
        {
            var user = HttpContext.User;
            var claimsIdentity = user.Identity as ClaimsIdentity;
            var idclaim = claimsIdentity.FindFirst("VoterId");
            var id = idclaim.Value;
            VoterRecordModel recordModel = new VoterRecordModel();
            recordModel.VoterId = Convert.ToInt32(id);
            recordModel.Year = model.NominatedYear;
            recordModel.Status = true;
            string SP = @"SP_VoteCount";
            var parameters = _dapperService.AddParam(model);
            parameters.Add("@flag", 'S');
            var selectCandidate = _dapperService.SPQuery<VoteCountModel>(SP, parameters).FirstOrDefault();
            if (selectCandidate!=null)
            {
                model.VoteReceived = selectCandidate.VoteReceived;
                var param = _dapperService.AddParam(model);
                param.Add("@flag", 'U');
                int updateVoteCount = _dapperService.SPExecute(SP, param);
                return Ok("Vote Added");
            }
            var parameter = _dapperService.AddParam(model);
            parameter.Add("@flag", 'I');
            int insertCandidate = _dapperService.SPExecute(SP, parameter);
            if(insertCandidate>0)
            {
                recordParticipation(recordModel);
                _logger.LogInformation("Vote added and voter status updated");
                return Ok("Vote Added");
            }    
            return Ok("Addition unsuccessful");
        }

        private bool recordParticipation(VoterRecordModel model)
        {
            string SP = @"SP_RecordVoter";
            var param = _dapperService.AddParam(model);
            var result = _dapperService.SPExecute(SP, param);
            if (result != 1)
            {
                return false;
            }
            else
                return true;
        }
    }
}
