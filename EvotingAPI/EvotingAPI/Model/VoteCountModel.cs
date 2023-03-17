namespace EvotingAPI.Model
{
    public class VoteCountModel
    {
        public int CandidateId { get; set; }
        public int VoteReceived { get; set; }
        public string NominatedYear { get; set; }
    }

    public class VoterRecordModel
    {
        public int VoterId { get; set; }
        public string Year { get; set; }
        public bool Status { get; set; }
    }
}
