﻿using System.Drawing;

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
        
    }
}
