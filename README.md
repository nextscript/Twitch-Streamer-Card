<h1 align="center">Twitch Streamer Card</h1>

<p align="center"><img src="themes3.png" width="30%"> <img src="themes1.png" width="30%"> <img src="themes2.png" width="30%"></p>

<p align="center">
  A modern Twitch status card for Rainmeter that displays live streamer information directly on your Windows desktop.
</p>

<hr>

<h2>✨ Features</h2>

<ul>
  <li>Live Twitch preview image</li>
  <li>Stream status display</li>
  <li>Viewer count</li>
  <li>Live uptime</li>
  <li>Clickable Twitch channel link</li>
  <li>Automatic refresh</li>
  <li>Lightweight Rainmeter skin</li>
  <li>Modern dark card design</li>
</ul>

<h2>📸 Preview</h2>

<p>
  The skin creates a compact desktop card showing the streamer name, live preview image, status, viewers and live time.
</p>

<h2>📦 Requirements</h2>

<ul>
  <li>Windows 10 or Windows 11</li>
  <li><a href="https://www.rainmeter.net/">Rainmeter</a></li>
  <li>Internet connection</li>
</ul>

<h2>🚀 Installation</h2>

<ol>
  <li>Install Rainmeter.</li>
  <li>Download this repository.</li>
  <li>Copy the skin folder to:</li>
</ol>

<pre><code>Documents\Rainmeter\Skins\</code></pre>

<ol start="4">
  <li>Open Rainmeter.</li>
  <li>Click <strong>Refresh all</strong>.</li>
  <li>Load the skin from the Rainmeter manager.</li>
</ol>

<h2>⚙️ Configuration</h2>

<p>
  Open the <code>.ini</code> file and change the streamer name:
</p>

<pre><code>Streamer=gronkhtv</code></pre>

<p>
  Example:
</p>

<pre><code>Streamer=streamer name</code></pre>

<p>
  <strong>Important:</strong> The streamer name must always be written in lowercase.
</p>

<h2>🎨 Customization</h2>

<p>You can edit these variables inside the skin file:</p>

<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>Scale</code></td>
      <td>Changes the size of the card</td>
    </tr>
    <tr>
      <td><code>Streamer</code></td>
      <td>Twitch username</td>
    </tr>
    <tr>
      <td><code>ColorAccent</code></td>
      <td>Main accent color</td>
    </tr>
    <tr>
      <td><code>ColorBg</code></td>
      <td>Card background color</td>
    </tr>
    <tr>
      <td><code>CardW</code></td>
      <td>Card width</td>
    </tr>
    <tr>
      <td><code>CardH</code></td>
      <td>Card height</td>
    </tr>
  </tbody>
</table>

<h2>🔧 How It Works</h2>

<p>
  This Rainmeter skin uses the <code>WebParser</code> plugin to request Twitch-related data from an external API.
  The returned values are parsed and displayed inside the desktop card.
</p>

<pre><code>Rainmeter
  ↓
WebParser
  ↓
Twitch API / Custom API
  ↓
Parsed Stream Data
  ↓
Desktop Widget</code></pre>

<h2>🖼️ Twitch Preview Image</h2>

<p>
  The preview image is loaded from Twitch CDN:
</p>

<pre><code>https://static-cdn.jtvnw.net/previews-ttv/live_user_USERNAME-240x135.jpg</code></pre>

<h2>🔄 Auto Refresh</h2>

<p>
  The skin refreshes stream data and the preview image automatically.
</p>

<ul>
  <li>Streamer status updates</li>
  <li>Viewer count updates</li>
  <li>Live time updates</li>
  <li>Preview image updates</li>
</ul>

<h2>⚠️ Known Limitations</h2>

<ul>
  <li>Depends on the external API endpoint</li>
  <li>Uses HTML parsing instead of JSON</li>
  <li>No offline fallback image included</li>
  <li>Requires Twitch preview availability</li>
</ul>

<h2>💡 Planned Improvements</h2>

<ul>
  <li>JSON API support</li>
  <li>Twitch Helix API support</li>
  <li>Offline placeholder image</li>
  <li>Stream category display</li>
  <li>Follower goal support</li>
  <li>Better error handling</li>
  <li>Auto-hide when streamer is offline</li>
</ul>

<h2>📄 License</h2>

<p>
  This project is released under the MIT License.
</p>

<h2>🙏 Credits</h2>

<ul>
  <li><a href="https://www.rainmeter.net/">Rainmeter</a></li>
  <li><a href="https://dev.twitch.tv/">Twitch Developer Platform</a></li>
  <li>Twitch CDN preview image system</li>
</ul>
