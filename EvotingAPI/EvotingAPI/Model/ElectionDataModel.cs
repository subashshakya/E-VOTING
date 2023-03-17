using Microsoft.ML.Data;
using System.Drawing;

namespace EvotingAPI.Model
{
    public class TaxiTrip
    {
        [LoadColumn(0)]
        public string VendorId;
        [LoadColumn(1)]
        public string RateCode;
        [LoadColumn(2)]
        public float PassengerCount;
        [LoadColumn(3)]
        public float TripTime;
        [LoadColumn(4)]
        public float TripDistance;
        [LoadColumn(5)]
        public string PaymentType;
        [LoadColumn(6)]
        public float FareAmount;
    }
    public class TaxiTripFarePrediction
    {
        [ColumnName("Score")]
        public float FareAmount;
    }

    public class CandidateHistory
    {
        //[LoadColumn(0)]
        //public int CandidateId { get; set; }
        [LoadColumn(0)]
        public string year { get; set; }
        [LoadColumn(2)]
        public string candidate { get; set; }
        [LoadColumn(1)]
        public float votes{ get; set; }
        //[LoadColumn(4)]
        //public int Age { get; set; }
        //[LoadColumn(5)]
        //public int TotalVoter { get; set; }

    }
    public class VotePrediction
    {
        [ColumnName("Score")]
        public float Votes;
    }
}
