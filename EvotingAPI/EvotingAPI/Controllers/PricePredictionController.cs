using EvotingAPI.Model;
using Microsoft.AspNetCore.Mvc;
using Microsoft.ML;
using Microsoft.ML.Data;

namespace EvotingAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PricePredictionController : Controller
    {
        [HttpGet]
        public IActionResult predictPrice()
        {
            string trainPath = @"C:\Users\Nitish Raj\Downloads\taxi-fare-train.csv";
            string testPath = @"C:\Users\Nitish Raj\Downloads\taxi-fare-test.csv";
            MLContext mlContext = new MLContext(seed: 0);
            var model = Train(mlContext, trainPath);
            var metrices = Evaluate(mlContext, model, testPath);
            var fareamount = TestSinglePrediction(mlContext, model);
            return Ok();
        }
        private static ITransformer Train(MLContext mlContext, string dataPath)
        {
            // The IDataView object holds the training dataset 
            IDataView dataView = mlContext.Data.LoadFromTextFile<TaxiTrip>(dataPath, hasHeader: true, separatorChar: ',');

            var pipeline = mlContext.Transforms.CopyColumns(outputColumnName: "Label", inputColumnName: "FareAmount")
                .Append(mlContext.Transforms.Categorical.OneHotEncoding(outputColumnName: "VendorIdEncoded", inputColumnName: "VendorId"))
                .Append(mlContext.Transforms.Categorical.OneHotEncoding(outputColumnName: "RateCodeEncoded", inputColumnName: "RateCode"))
                .Append(mlContext.Transforms.Categorical.OneHotEncoding(outputColumnName: "PaymentTypeEncoded", inputColumnName: "PaymentType"))
                .Append(mlContext.Transforms.Concatenate("Features", "VendorIdEncoded", "RateCodeEncoded", "PassengerCount", "TripTime", "TripDistance", "PaymentTypeEncoded"))
                .Append(mlContext.Regression.Trainers.FastTree());

            //Create the model
            var model = pipeline.Fit(dataView);

            //Return the trained model
            return model;
        }
        private static RegressionMetrics Evaluate(MLContext mlContext, ITransformer model, string _testDataPath)
        {
            IDataView dataView = mlContext.Data.LoadFromTextFile<TaxiTrip>(_testDataPath, hasHeader: true, separatorChar: ',');
            var predictions = model.Transform(dataView);
            var metrics = mlContext.Regression.Evaluate(predictions, "Label", "Score");
            return metrics;
        }
        private static float TestSinglePrediction(MLContext mlContext, ITransformer model)
        {
            var predictionFunction = mlContext.Model.CreatePredictionEngine<TaxiTrip, TaxiTripFarePrediction>(model);

            //Create a single TaxiTrip object to be used for predictin
            var taxiTripSample = new TaxiTrip()
            {
                VendorId = "CMT",
                RateCode = "1",
                PassengerCount = 2,
                TripTime = 1250,
                TripDistance = 3.69f,
                PaymentType = "CSH",
                FareAmount = 0
            };
            //Make a prediction
            var prediction = predictionFunction.Predict(taxiTripSample);
            return prediction.FareAmount;
        }
    }
}
