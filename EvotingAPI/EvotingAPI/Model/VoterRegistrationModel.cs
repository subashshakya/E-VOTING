namespace EvotingAPI.Model
{
    public class VoterRegistrationModel
    {
        public int VoterId { get; set; }
        public string CitizenshipId { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastName { get; set; }
        public string DateOfbirth { get; set; }
        public string Gender { get; set; }
        public string  Address { get; set; }
        public string State { get; set; }
        public string District { get; set; }
        public int WardNo { get; set; }
        public string Municipality { get; set; }
    }
}
