using EvotingAPI.Model;
using Microsoft.AspNetCore.Mvc;

namespace EvotingAPI.Controllers
{

    [ApiController]
    [Route("api/[Controller]")]
    public class VoteCountCrontrller : Controller
    {
        private readonly IDapperService _dapperService;
        private readonly ILogger<VoteCountCrontrller> _logger;
        public VoteCountCrontrller(IDapperService dapperService, ILogger<VoteCountCrontrller> logger)
        {
            _dapperService=dapperService;
            _logger=logger;
        }
        [HttpPost]
        [Route("CountVote")]
        public IActionResult CountVote([FromBody] VoteCountModel model)
        {
            //string sql=@"select * from VoteCount where "
            return Ok("Added");
        }
    }
}
