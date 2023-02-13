using System.ComponentModel.DataAnnotations;

namespace EvotingAPI.Model
{
    public class VoterModel
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "VoterId is Required")]
        [Range(100000, 999999, ErrorMessage = "VoterId not valid")]
        public int VoterId { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "CitizenshipId is required")]
        [StringLength(15,ErrorMessage ="CitizenshipId not valid",MinimumLength =10)]
        public string CitizenshipId { get; set; }
    }
}
