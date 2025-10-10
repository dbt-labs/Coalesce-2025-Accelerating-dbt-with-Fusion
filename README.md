# Welcome to the Accelerating dbt with Fusion Workshop! 

### Getting Started:

1. If you already have a dbt account, log out first.
2. Sign up for a new account: https://workshops.us1.dbt.com/workshop
3. Fill out the form, choosing the Accelerating dbt with Fusion workshop. You will be provided a password to use for this Coalesce workshop!
4. Submitting the form will launch dbt. Launch dbt Studio.
5. Try running dbt build in the command bar at the bottom of your IDE.

### 🥪 The Jaffle Shop 🦘

This is a sandbox project for exploring the basic functionality and latest features of dbt Fusion. 
It's based on a fictional restaurant called the Jaffle Shop that serves [jaffles](https://en.wikipedia.org/wiki/Pie_iron).

The source and staging layers have already been built for you.
Intentionally, only the dim_customers in the marts layer has been built for you. This is to enable you to play around with dbt Fusion while developing.
Fact and dimension tables aim to answer potential business questions that may arise.

The facts represent an event (i.e. an order placed, a project created, etc.)
The dimension describes that event (i.e. customer, location, etc.)
Together, facts and dimensions are able to form a well-rounded analysis, i.e. customer placing an order

For those looking for inspiration, imagine that you are building out marts to answer the following questions:
- Which customer has visited the most locations?
- List the most loyal customer per location?
- Has anyone ordered anything?

Ready to go? Let's dig in!

### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [dbt community](https://getdbt.com/community) to learn from other analytics engineers
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
