import '../models/article.dart';

List<Article> getSampleArticles() {
  return [
    Article(
      id: '1',
      title: 'Apple Unveils Revolutionary AI Chip for Next Generation Devices',
      summary:
          'Apple announces groundbreaking M4 chip with integrated neural engine, promising unprecedented AI performance.',
      imageUrl: 'https://picsum.photos/seed/tech1/800/400',
      category: 'Tech',
      date: DateTime(2024, 12, 20),
      fullContent: '''
Apple has unveiled its latest innovation: the M4 chip, featuring a revolutionary neural engine designed specifically for AI workloads. This new chip represents a significant leap forward in computing power and efficiency.

The M4 chip boasts a 16-core neural engine capable of performing up to 38 trillion operations per second, making it one of the most powerful AI processors available in consumer devices. The chip also features improved power efficiency, with Apple claiming up to 40% better battery life compared to previous generations.

Industry experts are calling this release a game-changer, as it positions Apple at the forefront of the AI revolution. The M4 chip will power the next generation of MacBooks, iPads, and other Apple devices, bringing advanced AI capabilities to millions of users worldwide.

Software developers are already excited about the possibilities, with many planning to leverage the chip's capabilities for machine learning applications, real-time video processing, and advanced computational photography.
      ''',
    ),
    Article(
      id: '2',
      title: 'Global Tech Summit 2024 Highlights Latest Innovations',
      summary:
          'Leading tech companies showcase cutting-edge technologies including quantum computing and advanced robotics.',
      imageUrl: 'https://picsum.photos/seed/tech2/800/400',
      category: 'Tech',
      date: DateTime(2024, 12, 19),
      fullContent: '''
The Global Tech Summit 2024 concluded yesterday with spectacular demonstrations of next-generation technologies. Over 500 companies from 40 countries participated in this year's event, showcasing innovations that promise to reshape our digital future.

Quantum computing took center stage, with several companies demonstrating practical applications for cryptography and drug discovery. IBM presented a 1,000-qubit quantum processor, while Google showcased advances in quantum error correction.

Robotics was another highlight, with Boston Dynamics revealing new humanoid robots capable of complex tasks in industrial settings. These robots demonstrated unprecedented dexterity and adaptability, suggesting a future where human-robot collaboration becomes commonplace.

The summit also featured presentations on sustainable technology, with companies demonstrating how AI and IoT can help address climate change through smarter energy management and resource optimization.
      ''',
    ),
    Article(
      id: '3',
      title: 'Champions League: Dramatic Comeback Secures Final Spot',
      summary:
          'Manchester City overturns 2-goal deficit to reach Champions League final in thrilling match.',
      imageUrl: 'https://picsum.photos/seed/sports1/800/400',
      category: 'Sports',
      date: DateTime(2024, 12, 18),
      fullContent: '''
In what will be remembered as one of the greatest Champions League comebacks, Manchester City defeated Real Madrid 3-2 to secure their place in the final. The English side faced a daunting 2-0 deficit at halftime but rallied with three unanswered goals in the second half.

Erling Haaland scored twice in the comeback, with Kevin De Bruyne providing the winning goal in the 88th minute. The Etihad Stadium erupted as the Belgian midfielder's strike found the back of the net, completing one of the most remarkable turnarounds in recent memory.

Manager Pep Guardiola praised his team's resilience: "This team never gives up. The character they showed tonight is what champions are made of." The victory sets up a mouth-watering final against Bayern Munich next month.

Manchester City will be looking to claim their second Champions League title, having won their first just two years ago. With their current form and squad depth, they enter the final as slight favorites.
      ''',
    ),
    Article(
      id: '4',
      title: 'Olympic Star Breaks World Record in Spectacular Fashion',
      summary:
          'Track sensation shatters 100m world record, clocking an incredible 9.52 seconds.',
      imageUrl: 'https://picsum.photos/seed/sports2/800/400',
      category: 'Sports',
      date: DateTime(2024, 12, 17),
      fullContent: '''
Athletics history was made yesterday as Jamaica's rising star Marcus Thompson shattered the 100-meter world record, clocking an astonishing 9.52 seconds at the Diamond League meeting in Rome. The previous record of 9.58 seconds had stood for 15 years.

The 24-year-old sprinter delivered a perfect race, exploding from the blocks and maintaining incredible speed throughout. His reaction time of 0.121 seconds was followed by a powerful acceleration phase that left his competitors trailing.

"I knew I had something special in me today," Thompson said after the race. "Everything came together perfectly – my training, the weather conditions, and my mental preparation. This is a dream come true."

Sports scientists are already analyzing the performance, with many noting Thompson's exceptional technique and power-to-weight ratio. With the Olympics approaching, Thompson has established himself as the clear favorite for gold in the 100m sprint.
      ''',
    ),
    Article(
      id: '5',
      title: 'Stock Markets Surge on Positive Economic Data',
      summary:
          'Major indices hit record highs as inflation shows signs of cooling and unemployment remains low.',
      imageUrl: 'https://picsum.photos/seed/business1/800/400',
      category: 'Business',
      date: DateTime(2024, 12, 21),
      fullContent: '''
Stock markets around the world reached new record highs today following the release of encouraging economic data. The S&P 500 climbed 2.3%, while the Dow Jones Industrial Average gained 1.8%, both reaching all-time highs.

The rally was sparked by inflation data showing a continued cooling trend, with consumer prices rising just 2.4% year-over-year, down from 3.1% the previous month. This suggests the Federal Reserve's interest rate policies are having the desired effect without triggering a recession.

Unemployment data also exceeded expectations, remaining at a historically low 3.7%. Strong job growth combined with moderating inflation has created what economists call a "goldilocks scenario" – an economy that's neither too hot nor too cold.

Tech stocks led the gains, with major companies like Apple, Microsoft, and Nvidia all posting significant increases. Investors are optimistic about earnings reports expected next week, with many analysts raising their forecasts.

Financial experts caution that while the current outlook is positive, investors should remain vigilant about potential headwinds including geopolitical tensions and ongoing supply chain challenges.
      ''',
    ),
    Article(
      id: '6',
      title: 'Tech Giant Announces Major Expansion Plans',
      summary:
          'Amazon to invest \$10 billion in new data centers, creating 50,000 jobs across five countries.',
      imageUrl: 'https://picsum.photos/seed/business2/800/400',
      category: 'Business',
      date: DateTime(2024, 12, 16),
      fullContent: '''
Amazon has announced an ambitious \$10 billion investment plan to build new data centers across five countries, marking one of the largest infrastructure projects in the company's history. The expansion will create approximately 50,000 new jobs over the next three years.

The new facilities will be located in the United States, Germany, India, Australia, and Brazil, with each site featuring state-of-the-art technology and sustainable design. Amazon claims the data centers will run entirely on renewable energy by 2025.

CEO Andy Jassy explained the rationale: "As cloud computing and AI continue to grow exponentially, we need to expand our infrastructure to meet customer demands. This investment ensures we can continue delivering the best service while maintaining our commitment to sustainability."

The announcement has been welcomed by government officials in the selected countries, who praised Amazon for creating high-paying jobs and investing in local economies. Construction on the first facilities is expected to begin in Q2 2025.

Analysts view this move as strategic positioning against competitors like Microsoft Azure and Google Cloud, as the battle for cloud computing dominance intensifies.
      ''',
    ),
    Article(
      id: '7',
      title: 'Cybersecurity Experts Warn of New Ransomware Threat',
      summary:
          'Advanced malware targets critical infrastructure, prompting urgent security updates across industries.',
      imageUrl: 'https://picsum.photos/seed/tech3/800/400',
      category: 'Tech',
      date: DateTime(2024, 12, 15),
      fullContent: '''
Cybersecurity firms have issued urgent warnings about a sophisticated new ransomware variant dubbed "PhantomLock" that has successfully breached several major organizations worldwide. The malware specifically targets critical infrastructure including energy grids, healthcare systems, and financial institutions.

Unlike previous ransomware attacks, PhantomLock employs advanced AI techniques to evade detection and can remain dormant in systems for weeks before activation. Security researchers believe the malware is the work of a highly skilled group with nation-state backing.

"This represents a new evolution in cyber threats," explained Dr. Sarah Chen, chief security officer at CyberDefense Inc. "The sophistication level is unprecedented, and organizations need to take immediate action to protect their systems."

The FBI and international law enforcement agencies have launched a coordinated investigation. Meanwhile, cybersecurity companies are working around the clock to develop detection and removal tools.

Businesses are urged to update all security software, implement multi-factor authentication, conduct comprehensive security audits, and train employees on recognizing potential threats. The estimated global cost of PhantomLock attacks already exceeds \$2 billion.
      ''',
    ),
    Article(
      id: '8',
      title: 'Tennis: Rising Star Wins First Grand Slam Title',
      summary:
          '19-year-old sensation defeats veteran champion in five-set thriller at Australian Open.',
      imageUrl: 'https://picsum.photos/seed/sports3/800/400',
      category: 'Sports',
      date: DateTime(2024, 12, 14),
      fullContent: '''
The tennis world has a new champion as 19-year-old Sofia Martinez claimed her first Grand Slam title with a stunning victory at the Australian Open. The Spanish teenager defeated three-time champion Victoria Petrov 6-4, 4-6, 7-5 in a match that lasted over three hours.

Martinez showed remarkable composure, fighting back from a break down in the final set to claim victory. Her powerful serve and aggressive baseline play overwhelmed the more experienced Petrov, who struggled to cope with the youngster's pace.

"I can't believe this is happening," an emotional Martinez said during the trophy ceremony. "I've dreamed of this moment since I was a little girl. To win my first Grand Slam at 19 is incredible."

Tennis legends have been quick to praise Martinez's performance. Former champion Serena Williams tweeted: "The future of women's tennis is in great hands. What a player!"

With this victory, Martinez becomes the youngest Grand Slam champion in over a decade and establishes herself as a force to be reckoned with in women's tennis. Bookmakers have already installed her as the favorite for the upcoming French Open.
      ''',
    ),
    Article(
      id: '9',
      title: 'Startup Revolutionizes Electric Vehicle Charging',
      summary:
          'New technology promises full EV charge in just 5 minutes, disrupting the automotive industry.',
      imageUrl: 'https://picsum.photos/seed/business3/800/400',
      category: 'Business',
      date: DateTime(2024, 12, 22),
      fullContent: '''
A Silicon Valley startup has developed revolutionary charging technology that can fully charge an electric vehicle in just five minutes, potentially eliminating one of the biggest barriers to EV adoption. ChargeFast Inc. demonstrated the technology yesterday, charging a Tesla Model 3 from 0% to 100% in 4 minutes and 52 seconds.

The breakthrough comes from a new battery architecture and cooling system that can handle extremely high charging rates without degrading battery life. Traditional fast chargers typically require 30-45 minutes for a full charge, making the new technology a game-changer.

"This changes everything," said ChargeFast CEO Jennifer Liu. "With charging times comparable to filling up a gas tank, the last major objection to electric vehicles disappears."

Major automakers have expressed strong interest, with Tesla, Ford, and Volkswagen all in discussions about licensing the technology. The company has raised \$500 million in its latest funding round, valuing it at \$3 billion.

However, some experts caution that widespread deployment will require significant infrastructure upgrades to handle the higher power requirements. ChargeFast estimates it will take 3-5 years before the technology becomes widely available at public charging stations.
      ''',
    ),
    Article(
      id: '10',
      title: '5G Networks Reach 70% Global Coverage Milestone',
      summary:
          'Telecommunications companies celebrate major achievement as 5G becomes mainstream worldwide.',
      imageUrl: 'https://picsum.photos/seed/tech4/800/400',
      category: 'Tech',
      date: DateTime(2024, 12, 13),
      fullContent: '''
The telecommunications industry is celebrating a significant milestone as 5G networks now cover 70% of the global population, according to the Global Mobile Suppliers Association. This represents a dramatic increase from just 30% coverage two years ago.

The rapid expansion has been driven by massive infrastructure investments from carriers worldwide, with total spending on 5G infrastructure exceeding \$300 billion since 2020. The technology promises speeds up to 100 times faster than 4G, along with lower latency and greater capacity.

5G is enabling new applications across various sectors including autonomous vehicles, remote surgery, smart cities, and industrial automation. In South Korea, which leads in 5G adoption, over 95% of mobile users now have 5G access.

"We're entering a new era of connectivity," said Maria Rodriguez, CEO of Global Telecom Alliance. "5G isn't just about faster phones – it's the foundation for the next generation of digital innovation."

Developing nations are also seeing rapid 5G deployment, with India and several African countries announcing aggressive rollout plans. Experts predict that by 2026, 5G will cover over 90% of the world's population, truly making it a global standard for mobile connectivity.
      ''',
    ),
  ];
}
