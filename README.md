<!DOCTYPE html>
<html lang="en" dir="ltr">
<head>
  <meta charset="UTF-8">
  <title>Gen AI Chatbot</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      line-height: 1.8;
      padding: 20px;
      max-width: 1000px;
      margin: auto;
    }
    h1, h2, h3 {
      color: #333;
    }
    code, pre {
      background-color: #f5f5f5;
      padding: 5px 10px;
      border-radius: 5px;
      display: block;
      overflow-x: auto;
    }
    .section {
      border-bottom: 1px solid #ccc;
      margin-bottom: 40px;
      padding-bottom: 20px;
    }
    .rtl {
      direction: rtl;
      text-align: right;
    }
    img {
      max-width: 100%;
      height: auto;
    }
    .note {
      font-style: italic;
      color: #555;
    }
  </style>
</head>
<body>

<h1>Gen AI Chatbot</h1>
<p>Welcome to <strong>Gen AI Chatbot</strong>, a simple Flutter app that lets you chat with an AI-powered bot. This guide is provided in both <strong>English</strong> and <strong>فارسی</strong>.</p>

<div class="section">
  <h2>📱 What is This Project?</h2>
  <p><strong>English:</strong><br>
  Gen AI Chatbot is a mobile application built with Flutter. It allows users to interact with an AI chatbot through a clean and user-friendly interface. This project is a great starting point for learning Flutter and building AI-powered apps.</p>

  <div class="rtl">
    <strong>فارسی:</strong><br>
    Gen AI Chatbot یک اپلیکیشن موبایلی است که با Flutter ساخته شده. این اپ به کاربران اجازه می‌دهد از طریق یک رابط کاربری ساده و زیبا با یک ربات هوش مصنوعی تعامل داشته باشند. این پروژه یک نقطه شروع عالی برای یادگیری فلاتر و ساخت اپ‌های مبتنی بر هوش مصنوعی است.
  </div>
</div>

<div class="section">
  <h2>🖼️ Screenshot / اسکرین‌شات</h2>
  <img src="screenshot.png" alt="App Screenshot">
  <p class="note">English: The main interface where you chat with the AI.<br>
  فارسی: رابط اصلی که در آن با ربات گفت‌وگو می‌کنید.</p>
</div>

<div class="section">
  <h2>🚀 How to Run the App / نحوه اجرای اپ</h2>

  <h3>✅ Step 1: Install Flutter / نصب Flutter</h3>
  <p><strong>English:</strong></p>
  <ul>
    <li>Download and install Flutter from <a href="https://flutter.dev">flutter.dev</a>.</li>
    <li>Run this in your terminal:
      <pre><code>flutter doctor</code></pre>
    </li>
    <li>Follow instructions to fix any issues (e.g. Android Studio or Xcode).</li>
  </ul>

  <div class="rtl">
    <p><strong>فارسی:</strong></p>
    <ul>
      <li>Flutter را از <a href="https://flutter.dev">flutter.dev</a> دانلود و نصب کنید.</li>
      <li>در ترمینال اجرا کنید:
        <pre><code>flutter doctor</code></pre>
      </li>
      <li>در صورت وجود مشکل (مثل نبود Android Studio یا Xcode)، طبق دستور عمل برطرف کنید.</li>
    </ul>
  </div>

  <h3>📂 Step 2: Get the Project / دریافت پروژه</h3>
  <pre><code>git clone https://github.com/your-username/gen-ai-chatbot.git
cd gen-ai-chatbot</code></pre>

  <h3>📦 Step 3: Install Dependencies / نصب وابستگی‌ها</h3>
  <pre><code>flutter pub get</code></pre>

  <h3>▶️ Step 4: Run the App / اجرای اپلیکیشن</h3>
  <p><strong>English:</strong></p>
  <pre><code>flutter devices
flutter run</code></pre>
  <p>If multiple devices:</p>
  <pre><code>flutter run -d &lt;device-id&gt;</code></pre>

  <div class="rtl">
    <p><strong>فارسی:</strong></p>
    <pre><code>flutter devices
flutter run</code></pre>
    <p>اگر چند دستگاه دارید:</p>
    <pre><code>flutter run -d &lt;device-id&gt;</code></pre>
  </div>
</div>

<div class="section">
  <h2>🛠️ Troubleshooting / عیب‌یابی</h2>
  <p><strong>English:</strong></p>
  <ul>
    <li>Run <code>flutter doctor</code> again to check for problems.</li>
    <li>Make sure device or emulator is connected properly.</li>
    <li>Refer to <a href="https://docs.flutter.dev">Flutter documentation</a> for help.</li>
  </ul>

  <div class="rtl">
    <p><strong>فارسی:</strong></p>
    <ul>
      <li>اگر اپ اجرا نشد، دوباره <code>flutter doctor</code> را اجرا کنید.</li>
      <li>اطمینان حاصل کنید که دستگاه یا شبیه‌ساز به درستی متصل شده باشد.</li>
      <li>برای کمک بیشتر به <a href="https://docs.flutter.dev">مستندات Flutter</a> مراجعه کنید.</li>
    </ul>
  </div>
</div>

<div class="section">
  <h2>📁 Project Structure / ساختار پروژه</h2>
  <pre><code>lib/            # App source code / کد منبع اپ
pubspec.yaml    # Dependencies and configuration / وابستگی‌ها و تنظیمات</code></pre>
</div>

<div class="section">
  <h2>📚 Learn More / منابع یادگیری بیشتر</h2>
  <ul>
    <li><a href="https://flutter.dev/docs/get-started/codelab">Write your first Flutter app</a></li>
    <li><a href="https://flutter.dev/docs/cookbook">Flutter Cookbook</a></li>
    <li><a href="https://flutter.dev/docs">Flutter Documentation</a></li>
  </ul>
</div>

<div class="section">
  <h2>❓ Questions? / سوالی دارید؟</h2>
  <p><strong>English:</strong> If you encounter any issues, feel free to open an issue on GitHub.</p>
  <div class="rtl">
    <p><strong>فارسی:</strong> اگر مشکلی داشتید، در GitHub یک issue باز کنید.</p>
  </div>
</div>

<p><strong>Happy Coding! / کدنویسی‌تان پر بار!</strong></p>

</body>
</html>
