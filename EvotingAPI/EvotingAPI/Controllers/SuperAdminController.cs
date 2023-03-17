using Dapper;
using EvotingAPI.Model;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EvotingAPI.Controllers
{
    [ApiController]
    [Route("api/[Controller]")]
    [Authorize(Roles ="SuperAdmin,Admin")]
    public class SuperAdminController : Controller
    {
        private readonly IDapperService _dapperService;
        public SuperAdminController(IDapperService dapperService)
        {
            _dapperService = dapperService;
        }
        [HttpGet]
        [Route("GetTotalVote")]
        public IActionResult GetTotalVoteSubmited()
        {
            string sql = @"Select * from VoterRecord where year=@year and status=1";
            var param = new DynamicParameters();
            param.Add("@year", "2079");
            var result = _dapperService.Query<VoterRecordModel>(sql, param);
            return Ok(result);
        }
        [HttpGet]
        [Route("GetCount")]
        public IActionResult GetMaleandFemaleVoters()
        {
            string sqlForMaleVoterCount = @"select vl.VoterId,vl.Gender
                                                            from Voterlist vl
                                                            inner join VoterRecord as vr on vr.VoterId=vl.VoterId
                                                            where vr.Year=@year and vl.Gender='Male'";
            string sqlForFemaleVoterCount = @"select vl.VoterId,vl.Gender
                                                            from Voterlist vl
                                                            inner join VoterRecord as vr on vr.VoterId=vl.VoterId
                                                            where vr.Year=@year and vl.Gender='female'";

            var param = new DynamicParameters();
            param.Add("@year", "2079");
            var maleVoters = _dapperService.QueryCount(sqlForMaleVoterCount, param);
            var femaleVoters = _dapperService.QueryCount(sqlForFemaleVoterCount, param);
            List<int> VoteCount = new List<int>();
            VoteCount.Add(maleVoters);
            VoteCount.Add(femaleVoters);
            return Ok(VoteCount);
        }
    }
}
