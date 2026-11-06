namespace InternshipPortal.Models
{
    public enum ReviewStatus { Pending, Approved, Rejected }

    public class Review
    {
        public int FeedbackId { get; set; }
        public string StudentId { get; set; }
        public int SiteId { get; set; }
        public int Rating { get; set; }
        public string Comments { get; set; }
        public ReviewStatus Status { get; set; } = ReviewStatus.Pending;
    }
}