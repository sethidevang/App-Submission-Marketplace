TRUNCATE products;

INSERT INTO products (id, brand, name, category, icon, image, gradient_from, gradient_to, price, mrp, max_tenure, rating, reviews, variants, highlights, sort_order) VALUES

('iphone15','Apple','iPhone 15','Mobiles','phone','iphone15.jpg','#6C3CE0','#9169EE',
 79900, 79900, 24, 4.7, '12.4k',
 '[
   {"type":"Storage","options":[{"label":"128GB","delta":0},{"label":"256GB","delta":8000},{"label":"512GB","delta":20000}]},
   {"type":"Color","options":[
     {"label":"Black","hex":"#1c1c1e","delta":0,"image":"https://rukminim2.flixcart.com/image/3024/3024/xif0q/mobile/h/d/9/-original-imagtc2qzgnnuhxh.jpeg?q=90"},
     {"label":"Blue","hex":"#5773a0","delta":0,"image":"https://rukminim2.flixcart.com/image/3024/3024/xif0q/mobile/h/d/9/-original-imagtc2qzgnnuhxh.jpeg?q=90"},
     {"label":"Pink","hex":"#f3c6cf","delta":0,"image":"https://rukminim2.flixcart.com/image/3024/3024/xif0q/mobile/a/c/k/-original-imagtc5fuzkvczr7.jpeg?q=90"},
     {"label":"Green","hex":"#a9c0a4","delta":0,"image":"https://rukminim2.flixcart.com/image/3024/3024/xif0q/mobile/j/z/3/-original-imagtc5fqyz8tu4c.jpeg?q=90"}
   ]}
 ]'::jsonb,
 ARRAY['A16 Bionic chip for pro-level performance','48MP Main camera with 2x optical zoom','6.1" Super Retina XDR display','Free 1-year 1Fi warranty extension'],
 1),

('s24ultra','Samsung','Galaxy S24 Ultra','Mobiles','phone','s24ultra.jpg','#2E4CB0','#5C74D6',
 119999, 129999, 18, 4.6, '8.9k',
 '[
   {"type":"Storage","options":[{"label":"256GB","delta":0},{"label":"512GB","delta":12000}]},
   {"type":"Color","options":[{"label":"Titanium Black","hex":"#2b2b2f","delta":0},{"label":"Titanium Grey","hex":"#8b8d92","delta":0},{"label":"Titanium Violet","hex":"#a89bd1","delta":0}]}
 ]'::jsonb,
 ARRAY['Snapdragon 8 Gen 3 for Galaxy','200MP camera with AI ProVisual Engine','Built-in S Pen for notes on the go','5000mAh battery, 45W fast charging'],
 2),

('mba-m2','Apple','MacBook Air M2','Laptops','laptop','mba-m2.jpg','#3E4C6D','#6B7C9E',
 104900, 114900, 24, 4.8, '5.2k',
 '[
   {"type":"Storage","options":[{"label":"256GB","delta":0},{"label":"512GB","delta":15000}]},
   {"type":"Color","options":[{"label":"Midnight","hex":"#2a2f3a","delta":0},{"label":"Starlight","hex":"#e6dfd0","delta":0},{"label":"Silver","hex":"#d6d8db","delta":0}]}
 ]'::jsonb,
 ARRAY['Apple M2 chip with 8-core CPU','Up to 18 hours of battery life','13.6" Liquid Retina display','Fanless design, completely silent'],
 3),

('bravia55','Sony','Bravia 55" 4K Google TV','TV & Audio','tv','bravia55.jpg','#0F8B8D','#22B6B0',
 64990, 74990, 12, 4.5, '3.1k',
 '[
   {"type":"Size","options":[{"label":"55\"","delta":0},{"label":"65\"","delta":25000}]}
 ]'::jsonb,
 ARRAY['4K HDR Processor X1 for lifelike picture','Dolby Vision & Dolby Atmos support','Google TV built-in with voice remote','3-year comprehensive 1Fi warranty'],
 4),

('boat-rockerz','boAt','Rockerz 550 Headphones','TV & Audio','headphones','boat-rockerz.jpg','#D8547A','#F0839B',
 1799, 3499, 6, 4.3, '45k',
 '[
   {"type":"Color","options":[{"label":"Black","hex":"#222222","delta":0},{"label":"Red","hex":"#c23b3b","delta":0},{"label":"Blue","hex":"#3b5fc2","delta":0}]}
 ]'::jsonb,
 ARRAY['Up to 20 hours of playback time','50mm drivers for immersive bass','Beast Mode for low-latency gaming','IPX4 sweat & splash resistant'],
 5),

('lg-washer','LG','7kg Front Load Washer','Appliances','washer','https://rukminim2.flixcart.com/image/3024/3024/xif0q/washing-machine-new/c/d/1/-original-imahpcyxyudynapc.jpeg?q=90','#C97A1E','#E8A93F',
 36990, 42990, 12, 4.4, '2.7k',
 '[]'::jsonb,
 ARRAY['AI Direct Drive motor adapts wash motion','6 Motion DD reduces fabric damage','Steam wash removes 99.9% allergens','10-year motor warranty included'],
 6),

('watch-s9','Apple','Watch Series 9','Wearables','watch','watch-s9.jpg','#B01860','#DE4A8D',
 39900, 41900, 12, 4.7, '6.3k',
 '[
   {"type":"Size","options":[{"label":"41mm","delta":0},{"label":"45mm","delta":3000}]},
   {"type":"Color","options":[{"label":"Midnight","hex":"#2a2f3a","delta":0},{"label":"Starlight","hex":"#e6dfd0","delta":0},{"label":"Pink","hex":"#f3c6cf","delta":0}]}
 ]'::jsonb,
 ARRAY['Always-on Retina display','ECG app and Blood Oxygen sensing','S9 chip with on-device Siri','watchOS 10 with new watch faces'],
 7),

('dyson-purifier','Dyson','Pure Cool Air Purifier','Appliances','wind','dyson-purifier.jpg','#0D74B8','#3FA8E8',
 32900, 38900, 9, 4.6, '1.4k',
 '[]'::jsonb,
 ARRAY['HEPA H13 filtration captures 99.95% particles','Air Multiplier technology, whole-room flow','Real-time air quality display on LCD','Whisper-quiet mode for night use'],
 8);
