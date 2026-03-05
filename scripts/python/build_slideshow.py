"""
Build professional HTML slideshow from all screenshots.
Creates a beautiful presentation with chapters, navigation, and Myanmar captions.

Run: python build_slideshow.py
"""
import os
import json
from pathlib import Path
from datetime import datetime


# Chapter definitions with Myanmar captions
CHAPTERS = [
    {
        'title': 'ဆိုင်မှတ်ပုံတင်နှင့် Setup',
        'subtitle': 'Day 1-2: Shop Registration & Setup',
        'folder': 'owner',
        'images': [
            ('01_dashboard.png', 'Dashboard - Owner View (Revenue, Alerts, Notifications)', 'Day 1'),
            ('02_pl_report.png', 'P&L Report (with Charts)', 'Day 1'),
            ('03_user_management.png', 'User Management - All 11 Roles Visible', 'Day 2'),
            ('04_settings.png', 'Settings Page', 'Day 1'),
            ('05_license_status.png', 'License Status', 'Day 1'),
        ]
    },
    {
        'title': 'ဝန်ထမ်းများ Role များ',
        'subtitle': 'Day 2: Staff Setup (All 11 Roles)',
        'folder': 'manager',
        'images': [
            ('01_dashboard.png', 'Manager Dashboard', 'Day 2'),
            ('02_sales_history.png', 'Sales History - All Transactions', 'Day 2'),
            ('03_inventory_levels.png', 'Inventory Overview', 'Day 2'),
            ('04_installation_dashboard.png', 'Installation Dashboard', 'Day 2'),
            ('05_reports_overview.png', 'Reports Overview', 'Day 2'),
        ]
    },
    {
        'title': 'ကုန်ပစ္စည်းများ ထည့်သွင်းခြင်း',
        'subtitle': 'Day 3-4: Inventory Setup & Stock Inbound',
        'folder': 'inventory_manager',
        'images': [
            ('01_products_list.png', 'Products List with USD Prices', 'Day 3'),
            ('02_stock_movement.png', 'Stock Movement History', 'Day 4'),
            ('03_categories.png', 'Product Categories', 'Day 3'),
            ('04_transfer_page.png', 'Stock Transfer Page', 'Day 4'),
            ('05_low_stock.png', 'Low Stock Notifications', 'Day 4'),
        ]
    },
    {
        'title': 'ရောင်းချမှုများ',
        'subtitle': 'Day 5-7: First Sales Week',
        'folder': 'sale_staff',
        'images': [
            ('01_pos_sales_request.png', 'POS/Sales Request Page', 'Day 5'),
            ('02_product_search.png', 'Product Search & Barcode Scanner UI', 'Day 5'),
            ('03_bundle_selection.png', 'Bundle Selection - 3KW Home Solar System', 'Day 6'),
            ('04_cart_payment.png', 'Cart & Payment Methods', 'Day 6'),
            ('05_invoice_preview.png', 'Invoice Print Preview', 'Day 7'),
        ]
    },
    {
        'title': 'Dollar နှုန်းပြောင်းလဲမှု',
        'subtitle': 'Day 8, 18: USD Rate Changes & Auto Repricing',
        'folder': 'special',
        'images': [
            ('01_usd_rate_before.png', 'USD Rate Change - Products Page (Before: 3450 MMK)', 'Day 8'),
            ('02_approval_pending.png', 'Approval Flow - Pending Sale', 'Day 5'),
            ('03_approval_approved.png', 'Approval Flow - Approved Transition', 'Day 5'),
        ]
    },
    {
        'title': 'တပ်ဆင်ရေးလုပ်ငန်း',
        'subtitle': 'Day 10-14: Installation Jobs',
        'folder': 'technician',
        'images': [
            ('01_installation_management.png', 'Installation Management', 'Day 10'),
            ('03_installation_detail.png', 'Installation Detail View (with Signature UI)', 'Day 14'),
            ('02_service_management.png', 'Service Management', 'Day 14'),
            ('04_repair_calendar.png', 'Repair Calendar', 'Day 14'),
        ]
    },
    {
        'title': 'အာမခံနှင့် ပြင်ဆင်ရေး',
        'subtitle': 'Day 16: Warranty Claims & Repairs',
        'folder': 'special',
        'images': [
            ('04_serial_assignment.png', 'Serial Number Assignment in Sale', 'Day 5'),
            ('05_warranty_records.png', 'Warranty Auto-creation after Sale', 'Day 5'),
        ]
    },
    {
        'title': 'စာရင်းချုပ် P&L Report',
        'subtitle': 'Day 30: Month End Reports',
        'folder': 'owner',
        'images': [
            ('02_pl_report.png', 'Profit & Loss Report', 'Day 30'),
        ]
    },
    {
        'title': 'AI Insights & Special Features',
        'subtitle': 'Day 30: AI Insights, Notifications, Mobile View',
        'folder': 'special',
        'images': [
            ('06_barcode_generator.png', 'Barcode Generator for Product', 'Day 3'),
            ('07_ai_insights.png', 'AI Insights Page', 'Day 30'),
            ('08_notification_bell.png', 'Notification Bell with Unread Count', 'Day 30'),
            ('09_mobile_view.png', 'Mobile Responsive View (390x844)', 'Day 30'),
        ]
    },
    {
        'title': 'Public Pages',
        'subtitle': 'Public Access Pages (No Login Required)',
        'folder': 'public',
        'images': [
            ('01_repair_track.png', 'Repair Track Page (with Repair Job ID)', 'Public'),
            ('02_warranty_check.png', 'Warranty Check Page (with Serial Number)', 'Public'),
            ('03_license_activation.png', 'License Activation Page', 'Public'),
        ]
    },
]


def generate_html():
    """Generate the HTML slideshow."""
    # Escape JSON for JavaScript
    chapters_json = json.dumps(CHAPTERS, ensure_ascii=False).replace('</', '<\\/').replace('`', '\\`')
    html_content = f"""<!DOCTYPE html>
<html lang="my">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Solar POS System - Complete Feature Demo</title>
    <style>
        * {{
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }}
        
        body {{
            font-family: 'Segoe UI', 'Myanmar Text', 'Pyidaungsu', sans-serif;
            background: #1a1a1a;
            color: #e0e0e0;
            display: flex;
            height: 100vh;
            overflow: hidden;
        }}
        
        /* Sidebar */
        .sidebar {{
            width: 300px;
            background: #2d2d2d;
            border-right: 2px solid #444;
            overflow-y: auto;
            padding: 20px 0;
        }}
        
        .sidebar h1 {{
            font-size: 20px;
            padding: 0 20px 20px;
            color: #4CAF50;
            border-bottom: 2px solid #444;
            margin-bottom: 20px;
        }}
        
        .chapter {{
            padding: 14px 20px;
            cursor: pointer;
            border-left: 3px solid transparent;
            transition: all 0.3s;
        }}
        
        .chapter:hover {{
            background: #3d3d3d;
            border-left-color: #4CAF50;
        }}
        
        .chapter.active {{
            background: #3d3d3d;
            border-left-color: #4CAF50;
        }}
        
        .chapter-title {{
            font-weight: bold;
            color: #fff;
            margin-bottom: 4px;
            font-size: 14px;
        }}
        
        .chapter-subtitle {{
            font-size: 11px;
            color: #aaa;
        }}
        
        /* Main Content */
        .content {{
            flex: 1;
            display: flex;
            flex-direction: column;
            background: #fff;
            color: #333;
        }}
        
        .header {{
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }}
        
        .header h1 {{
            font-size: 32px;
            margin-bottom: 10px;
        }}
        
        .header .subtitle {{
            font-size: 18px;
            opacity: 0.9;
        }}
        
        .slide-container {{
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px;
            overflow: auto;
            background: #f5f5f5;
        }}
        
        .slide {{
            max-width: 1400px;
            width: 100%;
            display: none;
        }}
        
        .slide.active {{
            display: block;
        }}
        
        .slide-image {{
            width: 100%;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
            margin-bottom: 20px;
        }}
        
        .slide-info {{
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }}
        
        .slide-caption {{
            font-size: 24px;
            font-weight: bold;
            color: #333;
            margin-bottom: 12px;
        }}
        
        .slide-meta {{
            display: flex;
            gap: 15px;
            font-size: 14px;
            color: #666;
            flex-wrap: wrap;
        }}
        
        .badge {{
            display: inline-block;
            padding: 6px 14px;
            border-radius: 16px;
            font-size: 12px;
            font-weight: bold;
        }}
        
        .badge-role {{
            background: #e3f2fd;
            color: #1976d2;
        }}
        
        .badge-day {{
            background: #fff3e0;
            color: #f57c00;
        }}
        
        /* Navigation */
        .nav {{
            background: white;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-top: 2px solid #eee;
        }}
        
        .nav-button {{
            padding: 12px 28px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            transition: background 0.3s;
            font-weight: 500;
        }}
        
        .nav-button:hover {{
            background: #5568d3;
        }}
        
        .nav-button:disabled {{
            background: #ccc;
            cursor: not-allowed;
        }}
        
        .progress-bar {{
            flex: 1;
            height: 8px;
            background: #eee;
            border-radius: 4px;
            margin: 0 20px;
            overflow: hidden;
        }}
        
        .progress-fill {{
            height: 100%;
            background: linear-gradient(90deg, #667eea, #764ba2);
            transition: width 0.3s;
        }}
        
        .slide-counter {{
            font-size: 14px;
            color: #666;
            font-weight: 500;
        }}
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <h1>📚 Chapters</h1>
        <div id="chapters-list"></div>
    </div>
    
    <!-- Main Content -->
    <div class="content">
        <div class="header">
            <h1>Solar POS System</h1>
            <div class="subtitle">Complete Feature Demonstration - One Month Simulation</div>
        </div>
        
        <div class="slide-container">
            <div id="slides-container"></div>
        </div>
        
        <div class="nav">
            <button class="nav-button" id="prev-btn" onclick="previousSlide()">← Previous</button>
            <div class="progress-bar">
                <div class="progress-fill" id="progress-fill"></div>
            </div>
            <div class="slide-counter">
                <span id="current-slide">1</span> / <span id="total-slides">1</span>
            </div>
            <button class="nav-button" id="next-btn" onclick="nextSlide()">Next →</button>
        </div>
    </div>
    
    <script>
        // Slides data
        const chapters = JSON.parse(String.raw`{chapters_json}`);
        let allSlides = [];
        let currentSlideIndex = 0;
        
        // Build slides array
        chapters.forEach((chapter, chapterIndex) => {{
            chapter.images.forEach((image, imageIndex) => {{
                allSlides.push({{
                    chapterIndex: chapterIndex,
                    imageIndex: imageIndex,
                    chapter: chapter,
                    image: image[0],
                    caption: image[1],
                    day: image[2],
                    folder: chapter.folder
                }});
            }});
        }});
        
        // Initialize slideshow
        function initSlideshow() {{
            // Build sidebar
            const chaptersList = document.getElementById('chapters-list');
            chapters.forEach((chapter, index) => {{
                const chapterDiv = document.createElement('div');
                chapterDiv.className = 'chapter';
                chapterDiv.onclick = () => goToChapter(index);
                chapterDiv.innerHTML = `
                    <div class="chapter-title">${{chapter.title}}</div>
                    <div class="chapter-subtitle">${{chapter.subtitle}}</div>
                `;
                chaptersList.appendChild(chapterDiv);
            }});
            
            // Build slides
            const slidesContainer = document.getElementById('slides-container');
            allSlides.forEach((slide, index) => {{
                const slideDiv = document.createElement('div');
                slideDiv.className = 'slide';
                slideDiv.id = `slide-${{index}}`;
                slideDiv.innerHTML = `
                    <img src="screenshots/${{slide.folder}}/${{slide.image}}" 
                         alt="${{slide.caption}}" 
                         class="slide-image"
                         onerror="this.src='data:image/svg+xml,%3Csvg xmlns=\\'http://www.w3.org/2000/svg\\' width=\\'1200\\' height=\\'800\\'%3E%3Crect fill=\\'%23ddd\\' width=\\'1200\\' height=\\'800\\'/%3E%3Ctext x=\\'50%25\\' y=\\'50%25\\' text-anchor=\\'middle\\' fill=\\'%23999\\' font-size=\\'20\\'%3EImage not found: ${{slide.folder}}/${{slide.image}}%3C/text%3E%3C/svg%3E'">
                    <div class="slide-info">
                        <div class="slide-caption">${{slide.caption}}</div>
                        <div class="slide-meta">
                            <span class="badge badge-role">${{slide.chapter.title}}</span>
                            <span class="badge badge-day">${{slide.day}}</span>
                        </div>
                    </div>
                `;
                slidesContainer.appendChild(slideDiv);
            }});
            
            // Update counters
            document.getElementById('total-slides').textContent = allSlides.length;
            
            // Show first slide
            showSlide(0);
        }}
        
        function showSlide(index) {{
            if (index < 0 || index >= allSlides.length) return;
            
            // Hide all slides
            document.querySelectorAll('.slide').forEach(slide => {{
                slide.classList.remove('active');
            }});
            
            // Show current slide
            document.getElementById(`slide-${{index}}`).classList.add('active');
            
            // Update navigation
            currentSlideIndex = index;
            document.getElementById('current-slide').textContent = index + 1;
            document.getElementById('prev-btn').disabled = index === 0;
            document.getElementById('next-btn').disabled = index === allSlides.length - 1;
            
            // Update progress
            const progress = ((index + 1) / allSlides.length) * 100;
            document.getElementById('progress-fill').style.width = progress + '%';
            
            // Update active chapter
            document.querySelectorAll('.chapter').forEach((chapter, i) => {{
                chapter.classList.toggle('active', i === allSlides[index].chapterIndex);
            }});
            
            // Scroll sidebar to active chapter
            const activeChapter = document.querySelectorAll('.chapter')[allSlides[index].chapterIndex];
            if (activeChapter) {{
                activeChapter.scrollIntoView({{ behavior: 'smooth', block: 'nearest' }});
            }}
        }}
        
        function nextSlide() {{
            if (currentSlideIndex < allSlides.length - 1) {{
                showSlide(currentSlideIndex + 1);
            }}
        }}
        
        function previousSlide() {{
            if (currentSlideIndex > 0) {{
                showSlide(currentSlideIndex - 1);
            }}
        }}
        
        function goToChapter(chapterIndex) {{
            // Find first slide of this chapter
            const firstSlideIndex = allSlides.findIndex(slide => slide.chapterIndex === chapterIndex);
            if (firstSlideIndex !== -1) {{
                showSlide(firstSlideIndex);
            }}
        }}
        
        // Keyboard navigation
        document.addEventListener('keydown', (e) => {{
            if (e.key === 'ArrowRight' || e.key === 'ArrowDown') nextSlide();
            if (e.key === 'ArrowLeft' || e.key === 'ArrowUp') previousSlide();
            if (e.key === 'Home') showSlide(0);
            if (e.key === 'End') showSlide(allSlides.length - 1);
        }});
        
        // Initialize on load
        initSlideshow();
    </script>
</body>
</html>
"""
    
    # Save HTML file
    output_file = f'solar_pos_demo_{datetime.now().strftime("%Y-%m-%d")}.html'
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(html_content)
    
    print(f"[OK] Slideshow generated: {output_file}")
    print(f"   Open in browser to view the presentation")
    print(f"   Total slides: {sum(len(ch['images']) for ch in CHAPTERS)}")


if __name__ == '__main__':
    print("=" * 60)
    print("BUILDING HTML SLIDESHOW")
    print("=" * 60)
    
    # Check if screenshots directory exists
    if not os.path.exists('screenshots'):
        print("[!] Warning: screenshots/ directory not found")
        print("   Run screenshot_story.py first to capture screenshots")
    
    generate_html()
    
    print("=" * 60)
    print("[OK] DONE!")
    print("=" * 60)
