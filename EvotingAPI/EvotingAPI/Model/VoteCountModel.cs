namespace EvotingAPI.Model
{
    public class VoteCountModel
    {
        public int CandidateId { get; set; }
        public int VoteReceived { get; set; }
        public string NominatedYear { get; set; }
    }
}
