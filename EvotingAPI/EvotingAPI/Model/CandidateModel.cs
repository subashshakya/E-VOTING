using System.Drawing;

namespace EvotingAPI.Model
{
    public class CandidateModel
    {
        public int candidateId { get; set; }
        public string candidateFirstName { get; set; }
        public string candidateLastName { get; set; }
        public string candidatePhoto { get; set; }
        public string candidatePartyName { get; set; }
        public string candidatePartySymbol { get; set; }
        public string NominatedYear { get; set; }
        public string RomanizedCandidateFirstName { get; set; }
        public string RomanizedCandidateLastName  { get; set; }
        public string RomanizedCandidatePartyName { get; set; }

    }
    public class CandidateIdmodel
    {
        public int candidateId { get; set; }
    }
}
