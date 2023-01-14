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
using Neurotec.Biometrics;

using System.Drawing.Imaging;
using System.Security.Cryptography;
using System.Text;
using DPCtlUruNet;

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
        public IActionResult CreateFingerprintData([FromBody] string fingerprintdata)
        {

            byte[] decodeddata = Convert.FromBase64String(fingerprintdata);
            DataResult<Fmd> createFMD = Importer.ImportFmd(decodeddata, Constants.Formats.Fmd.DP_PRE_REGISTRATION, Constants.Formats.Fmd.DP_PRE_REGISTRATION);
            //var check2 = Importer.ImportFmd(decodeddata, Constants.Formats.Fmd.DP_VERIFICATION, Constants.Formats.Fmd.DP_VERIFICATION);
            //var fmd2 = check2.Data;
            List<Fmd> list = new List<Fmd>();
            list.Add(createFMD.Data);
            list.Add(createFMD.Data);
            list.Add(createFMD.Data);
            list.Add(createFMD.Data);
            var result=Enrollment.CreateEnrollmentFmd(Constants.Formats.Fmd.DP_REGISTRATION, list);
            var fmd = result.Data;
            var save = fmd.Bytes;
            string sql = @"Insert into fingerdata values(@finngerprint)";
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
        public IActionResult Verify([FromBody] string fingerprintdata)
        {
            byte[] decodedata = Convert.FromBase64String(fingerprintdata);
            DataResult<Fmd> createFMD = Importer.ImportFmd(decodedata, Constants.Formats.Fmd.DP_VERIFICATION, Constants.Formats.Fmd.DP_VERIFICATION);
            
            string sql = @"Select finngerprint from fingerdata where id=@id ";
            var param = _dapper.AddParam(1);
            var result = _dapper.Query<byte[]>(sql, param).FirstOrDefault();
            DataResult<Fmd> createFMDfromStoredData = Importer.ImportFmd(result, Constants.Formats.Fmd.DP_REGISTRATION, Constants.Formats.Fmd.DP_REGISTRATION);
            var compareResult = Comparison.Compare(createFMD.Data, 0, createFMDfromStoredData.Data, 0);
            if(compareResult.Score==0 || compareResult.Score<= 21474)
            {
                return Ok("Verified");
            }
            else if(compareResult.Score>21474 && compareResult.Score<= 2147483)
            {
                return BadRequest("please place your finger again");
            }

            return BadRequest("Not Verified");
        }
    }
}
