Hospital Patient Flow and Billing System

This project is a database management system developed for a hospital environment. The main purpose is to manage the complete journey of a patient from admission to discharge while maintaining accurate billing, insurance, and departmental records.

The system begins with patient registration, where patient information is stored in the PATIENTS table. When a patient is admitted, an admission record is created in the ADMISSIONS table. During treatment, a patient may move between different departments such as Cardiology, ICU, or General Ward, and these movements are tracked using the DEPARTMENT_STAYS table.

Medical services provided to patients are stored in the SERVICES table, while all charges are recorded in the BILLING_ITEMS table. The system also supports insurance processing through INSURANCE_PANELS, TARIFF_RATES, and PRE_AUTHORIZATIONS, allowing hospitals to manage insured patients and approved coverage limits.

To improve database functionality, advanced SQL features were implemented. A View provides a summary of patient admission information, a Stored Procedure generates patient bills, a Trigger automatically records billing modifications in an audit log, and Transactions ensure safe discharge processing.

The database was normalized up to Third Normal Form (3NF) to reduce redundancy and maintain data integrity. Relationships between tables were represented through Conceptual and Physical ERDs, and all business rules were documented.

Overall, the project provides a structured and efficient way to manage patient flow, billing operations, insurance handling, and record tracking within a hospital using SQL Server.