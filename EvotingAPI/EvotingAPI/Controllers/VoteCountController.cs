using Dapper;
using EvotingAPI.Model;
using Microsoft.AspNetCore.Mvc;

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
        public IActionResult CountVote([FromBody] VoteCountModel model)
        {
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
            return Ok("Vote Added");
        }
    }
}
