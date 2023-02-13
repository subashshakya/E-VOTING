using EvotingAPI.Model;
using Microsoft.AspNetCore.Mvc;
using Microsoft.ML;
using Microsoft.ML.Data;
using System.Diagnostics;
using System.Runtime.InteropServices;

namespace EvotingAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PredictionController : Controller
    {
        private readonly IDapperService _dapperService;
        public PredictionController(IDapperService dapperService)
        {
            _dapperService = dapperService;
        }
        //[HttpGet]
        //public IActionResult Getdata()
        //{
        //    string sql = @"Select * from candidatehistory";
        //    var list = _dapperService.Query<ElectionDataModel>(sql).ToList();
        //    //var processedData = list
        //    //                         .Where(data => !string.IsNullOrEmpty(data.CandidateName) && !string.IsNullOrEmpty(data.CandidatePartyName))
        //    //                         .Select(data => new { data.CandidateName, data.CandidatePartyName, data.VoteReceived, data.NominatedYear });

        //    var processedData = data.ToList();
        //    int trainingSetSize = (int)(processedData.Count() * 0.7);

        //    var trainingSet = processedData.Take(trainingSetSize);
        //    var testSet = processedData.Skip(trainingSetSize);

        //    var context = new MLContext();
        //    var dataView = context.Data.LoadFromEnumerable(trainingSet);
        //    var traindata = context.Data.TrainTestSplit(dataView, testFraction: 0.2).TrainSet;
        //    var pipeline = context.Transforms.Categorical.OneHotEncoding("CandidateName")
        //                    .Append(context.Transforms.Categorical.OneHotEncoding("CandidatePartyName"))
        //                    .Append(context.Transforms.Concatenate("Features", new[] { "CandidateName", "CandidatePartyName" ,"NominatedYear"}))
        //                    .Append(context.Regression.Trainers.LbfgsPoissonRegression("VoteReceived"));
        //    var model = pipeline.Fit(traindata);
        //    var prediction = model.Transform(dataView);
        //    var metrices = context.Regression.Evaluate(prediction, "VoteReceived");
        //    return Ok();
        //}
        [HttpGet]
        public IActionResult getdata()
        {
                string trainPath = @"D:\py\Vote-train.csv";
                string testPath = @"C:\Users\Nitish Raj\OneDrive\Desktop\Vote-test.csv";
                MLContext mlContext = new MLContext(seed: 0);
                IDataView dataView = mlContext.Data.LoadFromTextFile<CandidateHistory>(trainPath, hasHeader: true, separatorChar: ',');
                var splits = mlContext.Data.TrainTestSplit(dataView, testFraction: 0.2);
                IDataView trainingData = splits.TrainSet;
                IDataView testData = splits.TestSet;
                var model = Train(mlContext, trainingData);
                var metrices = Evaluate(mlContext, model, testData);
                var fareamount = TestSinglePrediction(mlContext, model);
                return Ok();
        }
        
        private static ITransformer Train(MLContext mlContext, IDataView _trainset)
        {
            // The IDataView object holds the training dataset 
            //IDataView dataView = mlContext.Data.LoadFromTextFile<CandidateHistory>(dataPath, hasHeader: true, separatorChar: ',');
            //var splits = mlContext.Data.TrainTestSplit(dataView, testFraction: 0.2);
            //IDataView trainingData = splits.TrainSet;
            //IDataView testData = splits.TestSet;
            var pipeline = mlContext.Transforms.CopyColumns(outputColumnName: "Label", inputColumnName: "votes")
                .Append(mlContext.Transforms.Categorical.OneHotEncoding(outputColumnName: "YearEncoded", inputColumnName: "year"))
                .Append(mlContext.Transforms.Categorical.OneHotEncoding(outputColumnName: "CandidateEncoded", inputColumnName: "candidate"))
                //.Append(mlContext.Transforms.Categorical.OneHotEncoding(outputColumnName: "NominatedYearEncoded", inputColumnName: "NominatedYear"))
                //.Append(mlContext.Transforms.Categorical.OneHotEncoding(outputColumnName: "AgeEncoded", inputColumnName: "NominatedYear"))
                //.Append(mlContext.Transforms.Categorical.OneHotEncoding(outputColumnName: "TotalVoterEncoded", inputColumnName: "TotalVoter"))
                .Append(mlContext.Transforms.Concatenate("Features", "YearEncoded", "CandidateEncoded"))
                .Append(mlContext.Regression.Trainers.Sdca("votes"));

            //Create the model
            var model = pipeline.Fit(_trainset);

            //Return the trained model
            return model;
        }
        private static RegressionMetrics Evaluate(MLContext mlContext, ITransformer model, IDataView _testDataPath)
        {
            //IDataView dataView = mlContext.Data.LoadFromTextFile<CandidateHistory>(_testDataPath, hasHeader: true, separatorChar: ',');
            var predictions = model.Transform(_testDataPath);
            var metrics = mlContext.Regression.Evaluate(predictions, "Label", "Score");
            return metrics;
        }
        private static float TestSinglePrediction(MLContext mlContext, ITransformer model)
        {
            var predictionFunction = mlContext.Model.CreatePredictionEngine<CandidateHistory, VotePrediction>(model);

            //Create a single TaxiTrip object to be used for predictin
            var candidateHistory = new CandidateHistory()
            {
                candidate = "A",
                year = "2023",
                votes = 0
            };
            //Make a prediction
            var prediction = predictionFunction.Predict(candidateHistory);
            return prediction.Votes;
        }
    }
}
