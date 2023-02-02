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
namespace EvotingAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class BiometricController : Controller
    {
        private readonly ILogger<BiometricController> _logger;
        private readonly IDapperService _dapper;
        public BiometricController(ILogger<BiometricController> logger, IDapperService dapper)
        {
            _logger = logger;
            _dapper = dapper;
        }
        [HttpPost]
        [Route("Fmd")]
        public IActionResult CreateFingerprintData([FromBody] string[] fingerprintdata)
        {
            List<Fmd> list = new List<Fmd>();
            foreach (var data in fingerprintdata)
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
            string sql = @"Insert into fingerdata values(@finngerprint,789456)";
            DynamicParameters param = new DynamicParameters();
            param.Add("@finngerprint", save);
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
        public IActionResult Verify([FromBody] int VoterId)
        {
            var stopWatch = new Stopwatch();
            if (stopWatch.IsRunning)
            {
                var sec = stopWatch.Elapsed.Seconds;
                _logger.LogInformation("elapsed time {0}", sec);
                stopWatch.Stop();
                stopWatch.Reset();

            }
            stopWatch.Start();
            _logger.LogInformation("Verification started");
            while (stopWatch.Elapsed.Seconds != 10)
            {
                var check = compareData(VoterId);
                if (check == 1)
                {
                    return Ok("Verified");
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
            string checkfingerdatasql = @"Select VoterId from temp_fingerdata where VoterId=@id ";
            var parameter = _dapper.AddParam(id);
            var dataToVerify = _dapper.Query<FingerPrintDataModel>(checkfingerdatasql,parameter).OrderByDescending(x => x.createdDate).FirstOrDefault();
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
        [HttpGet]
        [Route("GetFingerPrint")]
        public IActionResult GetFingerPrint()
        {
            return View();
        }
    }
}
