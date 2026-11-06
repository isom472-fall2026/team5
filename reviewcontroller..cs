using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using InternshipPortal.Models;
using System.Threading.Tasks;
using System.Linq;

namespace InternshipPortal.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ReviewsController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public ReviewsController(ApplicationDbContext context)
        {
            _context = context;
        }

        [HttpGet("site/{siteId}")]
        public async Task<IActionResult> GetSiteReviews(int siteId)
        {
            var reviews = await _context.Reviews
                .Where(r => r.SiteId == siteId && r.Status == ReviewStatus.Approved)
                .ToListAsync();

            return Ok(reviews);
        }

        [HttpPost("submit")]
        public async Task<IActionResult> SubmitReview([FromBody] Review review)
        {
            if (!ModelState.IsValid || review.SiteId <= 0 || string.IsNullOrWhiteSpace(review.StudentId) || string.IsNullOrWhiteSpace(review.Comments))
            {
                return BadRequest(new { message = "Invalid input data." });
            }

            review.Status = ReviewStatus.Pending;
            _context.Reviews.Add(review);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Review submitted successfully and sent for moderation." });
        }
    }
}