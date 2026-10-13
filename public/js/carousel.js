document.querySelectorAll('.carousel-btn').forEach(btn => {
    btn.addEventListener('click', () => {
        const id = btn.dataset.target;
        const track = document.getElementById(`carousel-${id}`);

        const scrollAmount = 300; // distância do scroll

        if (btn.classList.contains('next')) {
            track.scrollLeft += scrollAmount;
        } else {
            track.scrollLeft -= scrollAmount;
        }
    });
});