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
        [Route("Verify")]
        public bool Verify([FromBody] CandidateModel model,CancellationToken cancellationToken)
        {
            string line = " ";
            Process process = new Process();
            try
            {
            _logger.LogInformation("Verification Started!");
                process.StartInfo.FileName = "C:\\BioaPp\\Biometric.exe";
                //process.StartInfo.FileName = Path.Combine(Directory.GetCurrentDirectory(), "BioaPp", "Biometric.exe");
                _logger.LogInformation(string.Format("App Location :{0}", process.StartInfo.FileName));
                process.StartInfo.Arguments = "C:\\Test.fpt";
                //process.StartInfo.Arguments = Path.Combine(Directory.GetCurrentDirectory(), "Fingerprint", "nitish2.fpt");
                _logger.LogInformation(string.Format("File Location :{0}", process.StartInfo.Arguments));
                process.StartInfo.UseShellExecute = false;
                process.StartInfo.RedirectStandardOutput = true;
                process.StartInfo.CreateNoWindow = true;
                _logger.LogInformation("Start app");
                process.Start();
                Thread.Sleep(5000);
                while (!process.StandardOutput.EndOfStream)
                {
                    line = process.StandardOutput.ReadLine();
                    // do something with line
                }
                process.WaitForExit();
                _logger.LogInformation("Output:" + line);
                if (line == "The fingerprint was VERIFIED")
                {
                    return true;
                }
                return false;
            }
            catch (Exception e)
            {
                _logger.LogError("Error Occured with Message: " + e.Message);
                throw;
            }

        }
        [HttpPost]
        [Route("test")]
        [AllowAnonymous]
        public IActionResult Save([FromBody] string fingerprintdata)
        {
            
            //DataResult<Fmd> resultConversion = FeatureExtraction.CreateFmdFromFid(fingerprintdata.data) 
            //Enrollment.CreateEnrollmentFmd(Constants.Formats.Fmd.ANSI, fingerprintdata);
            string sql = @"Insert into fingerprintdata values(@finngerprint)";
            DynamicParameters param = new DynamicParameters();
            param.Add("@finngerprint", fingerprintdata.ToString());
            var added =_dapper.Execute(sql, param);
            if (added == 1)
                return Ok("Saved");
          
            return BadRequest("error");
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
            var param = _dapper.AddParam(2);
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
