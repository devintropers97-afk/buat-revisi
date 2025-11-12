<section class="page-header bg-primary text-white py-5">
    <div class="container text-center">
        <h1>Blog Post</h1>
    </div>
</section>

<section class="py-5">
    <div class="container">
        <article>
            <h2><?= e(ucwords(str_replace('-', ' ', $slug))) ?></h2>
            <p class="text-muted"><?= format_date(today()) ?></p>
            <div class="blog-content">
                <p>Full blog post content here...</p>
            </div>
        </article>
    </div>
</section>
