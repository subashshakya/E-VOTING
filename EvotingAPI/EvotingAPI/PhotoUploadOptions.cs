using FlickrNet;

namespace EvotingAPI
{
    internal class PhotoUploadOptions
    {
        public string title { get; set; }
        public string Description { get; set; }
        public string Tags { get; set; }
        public bool PublicFlag { get; set; }
        public ContentType ContentType { get; set; }
        public SafetyLevel SafetyLevel { get; set; }
        public HiddenFromSearch HiddenFromSearch { get; set; }
        public Action<FlickrResult<string>> result { get; set; }
    }
}