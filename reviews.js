const API_BASE_URL = '/api/reviews';

async function loadSiteReviews(siteId) {
    const reviewsContainer = document.getElementById('reviewsContainer');
    try {
        const response = await fetch(${API_BASE_URL}/site/${siteId});
        if (!response.ok) throw new Error('Failed to fetch reviews.');
        const reviews = await response.json();
        
        if (reviews.length === 0) {
            reviewsContainer.innerHTML = '<p>No approved reviews found for this site.</p>';
            return;
        }
        
        reviewsContainer.innerHTML = reviews.map(review => `
            <div class="review-card">
                <p><strong>Student:</strong> ${review.studentId}</p>
                <p><strong>Rating:</strong> ${'★'.repeat(review.rating)}${'☆'.repeat(5 - review.rating)}</p>
                <p><strong>Comment:</strong> ${review.comments}</p>
            </div>
        `).join('');
    } catch (error) {
        reviewsContainer.innerHTML = <p class="error">Error loading reviews: ${error.message}</p>;
    }
}

async function handleReviewSubmit(event) {
    event.preventDefault();
    const feedbackMessage = document.getElementById('feedbackMessage');
    feedbackMessage.innerText = '';
    feedbackMessage.className = '';
    
    const siteId = parseInt(document.getElementById('siteId').value);
    const studentId = document.getElementById('studentId').value.trim();
    const rating = parseInt(document.getElementById('rating').value);
    const comments = document.getElementById('comments').value.trim();
    
    if (!siteId || !studentId || !rating || !comments) {
        feedbackMessage.innerText = 'Error: All required fields must be provided.';
        feedbackMessage.className = 'error';
        return;
    }
    
    const payload = { siteId, studentId, rating, comments };
    
    try {
        const response = await fetch(${API_BASE_URL}/submit, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        });
        
        const result = await response.json();
        
        if (response.ok) {
            feedbackMessage.innerText = result.message;
            feedbackMessage.className = 'success';
            document.getElementById('reviewForm').reset();
        } else {
            feedbackMessage.innerText = result.message || 'Error submitting review.';
            feedbackMessage.className = 'error';
        }
    } catch (error) {
        feedbackMessage.innerText = Network/System Error: ${error.message};
        feedbackMessage.className = 'error';
    }
}