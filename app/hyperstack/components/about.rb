class About < Markdown
MARKDOWN = <<MARKDOWN
## Why *ceaselessprayer.org*?
This little website was created to encourage and assist all of us to pray together and without ceasing
for God's mercy on us in this time of crisis.

In the book of Thessalonians Paul tells us to pray without ceasing.  There are many ways to understand this command
but I have always liked the story from the desert fathers where a monk explains that he achieves unceasing prayer
by praying when he can, and then relying on others to pray while he is eating or sleeping.

*By the way the complete story is at the end of this page.*

Like this monk we are living in the world and while as individuals we may not yet be able to achieve unceasing prayer, together we can offer
ceaseless prayers to God.

## How does it work?

Its simple!  When you go to the prayer page you will find orthodox prayers old and new suitable for this time of crisis.  You can use the site as
a little electronic prayer book, and while you pray it will help make that world map light up.  No login is needed, and we don't ask for your email
or spam you in any way.

## How long should I pray for?

It's up to you.  If you go through the basic prayers on the site it will take only about 10 minutes.

## How about my regular rule of prayer?

Our intention with this site is to encourage you to add *additional* time to your prayer life, especially at times you might not normally
pray.  If you do not already have a regular rule of prayer here are some resources to help you establish a daily rule of prayer:

+ [How Shold We Build Our Prayer Rule?](https://orthochristian.com/100366.html)
+ [A Sample Prayer Rule](https://www.orthodoxprayer.org/Prayer%20Rule.html)
+ [Reestablishing a Simple Prayer Rule - a Pod Cast](https://www.ancientfaith.com/podcasts/lawofthespirit/re_establishing_a_simple_prayer_rule)

## How does that Map work?

The map shows an approximation of where prayers have been offered in the last 24 hours.  The brighter the area, the more prayers have been said in that
location.  We don't know or ask for your precise location, so the map is just an estimation, but together we can light up the world.

## How can I help?

Pass the link to this site along to a friend, your priest, or anyone else you think might like to spend a few extra minutes a day in prayer.

If you would like to contribute content to any of these pages then email [ceaselessprayers@gmail.com](mailto:ceaselessprayers@gmail.com) with your suggestions.

If you are a developer, graphic or UX designer and would like to help improve the site, please visit our [github page](https://github.com/catmando/ceaselessprayer) for more info.

More importantly consider how you can put your prayers into action.
* Remember those who are alone.  Give them a call.
* Contribute to your local food bank.
* Contact your local hospital and offer to order take out for the caregivers.
* Remember to contribute financially to your local parish even if there are no services.
* Smile and wave to your neighbors.

## Who is behind this?

We are thankful for the many people and organizations that have contributed and inspired us in this effort:

* Fr Sergius, Abbot of St. Tikhon's Monastery
* Archbishop Michael, Bishop of NY and NJ (Orthodox Church in America)
* [catprint.com](www.catprint.com) for providing our website hosting.
* The prayer icon is from [Freepik](https://www.flaticon.com/authors/freepik) and [Flaticon.com](https://www.flaticon.com)
* [cthedot.de Icon Generator](https://cthedot.de/icongen/)
* The great open source software community that made this software possible

For more details visit our [github repo.](https://github.com/catmando/ceaselessprayer)


## Pray Without Ceasing
### A story from the desert fathers.
Some monks called Euchites, or ‘men of prayer’, once came to Lucius in the ninth region of Alexandria.

He asked them, ‘What manual work do you do?’

They said, ‘We do not work with our hands. We obey St Paul’s command and pray without ceasing’ (1 Thess. 5:17).

He said to them, ‘Don’t you eat?’

They said, ‘Yes, we do.’

He said to them: ‘When you are eating who prays for you?’

Then he asked them, ‘Don’t you sleep?’

They said, ‘Yes, we do.’

He said, ‘Who prays for you while you are asleep?’ and they could not answer him.

Then he said to them, ‘I may be wrong, brothers, but it seems to me that you don’t do what you say. I will show you how I pray without ceasing
although I work with my hands. With God’s help, I sit down with a few palm leaves, and plait them, and say,
‘Have mercy upon me, O God, after thy great mercy: and according to the multitude of thy mercies do away with mine iniquity’ (Ps. 51:1).

He asked them, ‘Is that prayer, or not?’

They said, ‘It’s prayer all right.’

He said, ‘When I spend all day working and praying in my heart, I make about sixteen pence.
Two of these I put outside the door, and with the rest I buy food. Whoever finds the two
pennies outside the door prays for me while I am eating and sleeping:

**and so by God’s grace I fulfil the text, “Pray without ceasing” (1 Thess. 5:17).**
MARKDOWN

  render do
    DIV(styles(:container)) do
      papers
    end
  end
end
