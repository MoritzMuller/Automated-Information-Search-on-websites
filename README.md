# Targeted information search

This repository might be of help for individuals that would like to collect similar information across a whole range of different websites. I demonstrate the feasibility of this via a targeted email address search of individuals (for intance to send a targeted survey to specialists in a certain field). For this demonstration, I am using the transparency lobbying register of the EU. The register contains the websites and names of EU specialists within multiple thousands of EU organizations across the EU. We can then search for email adresses for individuals within these companies to drastically improve survey response rates in comparison of contacting the general email addresses. 

There are many more usecases for this, for instance by searching for the mission and vision of organizations, or for operational information (e.g. budget, profit, stakeholder groups etc.)

# Workflow
1. Scrape websites and retrieve html versions (Script 01)
2. Clean html (Script 01)
3. Find RegEx pattern matches for email patterns and retrieve a list of (likely) email addresses per organization. (Script 01)
4. Create various versions of individual names that could be contained in a email address (Script 02)
5. Search for pattern matches between retrieved email addresses and names of inidviduals. I provide a greedy and a conservative approach, depending on what is needed. (Script 02)
