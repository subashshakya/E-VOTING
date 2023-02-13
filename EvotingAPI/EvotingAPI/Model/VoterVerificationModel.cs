using System.ComponentModel.DataAnnotations;

namespace EvotingAPI.Model
{
    public class VoterVerificationModel
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "VoterId is Required")]
        [Range(100000, 999999, ErrorMessage = "VoterId not valid")]
        public int VoterId { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "CitizenshipId is required")]
        [StringLength(15,ErrorMessage ="CitizenshipId not valid",MinimumLength =10)]
        [RegularExpression(@"^\d{2}-\d{2}-\d{5,}$",ErrorMessage ="The string must have the format XX-XX-XXXXX and X should be digits")]
        public string CitizenshipId { get; set; }
    }

    public class VoterIdModel
    {
        public int VoterId { get; set; }
    }
}
