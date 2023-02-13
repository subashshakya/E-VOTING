using Dapper;
using DPUruNet;
using EvotingAPI.Model;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Data;
using System.Diagnostics;
using System.Net.NetworkInformation;
using System.Runtime.Intrinsics.X86;
using System.Text.RegularExpressions;
using System.Drawing.Imaging;
using System.Security.Cryptography;
using System.Text;
using DPCtlUruNet;
using DPXUru;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

namespace EvotingAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class BiometricController : Controller
    {
        private readonly ILogger<BiometricController> _logger;
        private readonly IDapperService _dapper;
        private readonly IConfiguration _configuration;
        public BiometricController(ILogger<BiometricController> logger, IDapperService dapper, IConfiguration configuration)
        {
            _logger = logger;
            _dapper = dapper;
            _configuration = configuration;
        }
        [HttpPost]
        [Route("Fmd")]
        public IActionResult CreateFingerprintData([FromBody] string[] fingerprintdata)
        {
            var voterId = fingerprintdata[4].ToString();
            var fingerdata = fingerprintdata.ToList();
            fingerdata.RemoveAt(4);
            List<Fmd> list = new List<Fmd>();
            foreach (var data in fingerdata)
            {
                byte[] decodeddata = Convert.FromBase64String(data);
                DataResult<Fmd> createFMD = Importer.ImportFmd(decodeddata, Constants.Formats.Fmd.DP_PRE_REGISTRATION, Constants.Formats.Fmd.DP_PRE_REGISTRATION);
                list.Add(createFMD.Data);

            }
            //var check2 = Importer.ImportFmd(decodeddata, Constants.Formats.Fmd.DP_VERIFICATION, Constants.Formats.Fmd.DP_VERIFICATION);
            //var fmd2 = check2.Data;
            var result = Enrollment.CreateEnrollmentFmd(Constants.Formats.Fmd.DP_REGISTRATION, list);
            var fmd = result.Data;
            var save = fmd.Bytes;
            string sql = @"Insert into fingerdata values(@finngerprint,@VoterId)";
            DynamicParameters param = new DynamicParameters();
            param.Add("@finngerprint", save);
            param.Add("@VoterId", voterId);
            var added = _dapper.Execute(sql, param);
            //var compare = Comparison.Compare(fmd2, 0, fmd, 0);
            if (added == 1)
            {
                //Verify(fingerprintdata);
                return Ok("Saved");
            }
            return BadRequest("error");
        }
        [HttpPost]
        [Route("VerifyFingerPrint")]
        public IActionResult Verify([FromBody] VoterIdModel model)
        {
            var stopWatch = new Stopwatch();
            stopWatch.Start();
            _logger.LogInformation("Verification started");
            while (stopWatch.Elapsed.Seconds != 10)
            {
                var check = compareData(model.VoterId);
                if (check == 1)
                {
                    var token = Createtoken(model.VoterId);
                    return Ok(token);
                }
                if (check == 2)
                {
                    return BadRequest("Not verified");
                }
            }
            stopWatch.Stop();

            return Ok("Timeout");
        }
        private int compareData(int id)
        {
            #region oldcode
            //string checkfingerdatasql = @"Select VoterId from temp_fingerdata where VoterId=@id ";
            //var parameter = _dapper.AddParam(voterId);
            //var dataToVerify = _dapper.Query<FingerPrintDataModel>(checkfingerdatasql).OrderByDescending(x => x.createdDate).FirstOrDefault();
            //if (dataToVerify != null)
            //{
            //    _logger.LogInformation("stored data found");
            //    byte[] decodedata = Convert.FromBase64String(dataToVerify.FingerPrint);
            //    _logger.LogInformation("Creating fmd to verify");
            //    DataResult<Fmd> createFMD = Importer.ImportFmd(decodedata, Constants.Formats.Fmd.DP_VERIFICATION, Constants.Formats.Fmd.DP_VERIFICATION);
            //    string sql = @"Select finngerprint from fingerdata where VoterId=@id ";
            //    var param = _dapper.AddParam(voterId);
            //    var result = _dapper.Query<byte[]>(sql, param).FirstOrDefault();
            //    _logger.LogInformation("Creating fmd from stored data to verify");
            //    DataResult<Fmd> createFMDfromStoredData = Importer.ImportFmd(result, Constants.Formats.Fmd.DP_REGISTRATION, Constants.Formats.Fmd.DP_REGISTRATION);
            //    var compareResult = Comparison.Compare(createFMD.Data, 0, createFMDfromStoredData.Data, 0);
            //    _logger.LogInformation("Comparison completed score is:{0}", compareResult.Score);
            //    string deleteFingerdata = @"Truncate table temp_fingerdata";
            //    _dapper.Execute(deleteFingerdata);
            //    if (compareResult.Score == 0 || compareResult.Score <= 21474)
            //    {
            //        return (1);
            //        _logger.LogInformation("verified");

            //    }
            //    else if (compareResult.Score > 21474)
            //    {
            //        return (2);
            //    }
            //}
            //return (0);
            #endregion
            string checkfingerdatasql = @"Select VoterId from temp_fingerdata where VoterId=@id";
            var parameter = _dapper.AddParam(id);
            //var dataToVerify = _dapper.Query<FingerPrintDataModel>(checkfingerdatasql,parameter).OrderByDescending(x => x.createdDate).FirstOrDefault();
            var dataToVerify = _dapper.Query<FingerPrintDataModel>(checkfingerdatasql, parameter).FirstOrDefault();
            if (dataToVerify != null)
            {
                _logger.LogInformation("Figerprint verified");
                string deleteSql = @"delete  from temp_fingerdata where VoterId=@id";
                _logger.LogInformation("Figerprint deleted");
                var param = _dapper.AddParam(id);
                var result = _dapper.Execute(deleteSql,param);
                return (1);
            }
            else
            {
                return 0;
            }

        }
        private string Createtoken(int id)
        {
            List<Claim> claims = new List<Claim>()
            {
                new Claim(ClaimTypes.Role,"Voter"),
                new Claim("VoterId",id.ToString())
            };
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(
                                                _configuration.GetSection("AppSettings:Token").Value!));

            var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha512Signature);
            var token = new JwtSecurityToken(
                    claims: claims,
                    expires: DateTime.Now.AddDays(1),
                    signingCredentials: credentials
                   );
            var jwtToken = new JwtSecurityTokenHandler().WriteToken(token);
            return (jwtToken);
        }
    }
}
