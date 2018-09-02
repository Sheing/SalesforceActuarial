# SalesforceActuarial
The SalesforceActuarial library contains a simple ActuarialTable class for Mortality calculations leveraging Salesforce's native Custom Object and Fields.

# Getting Started: 
1. Create a Custom Object call Mortality_Table__c, with 3 fields (Age__c, Death_Probability_Male__c,Death_Probability_Female__c)
2. Upload your own Mortality Table to Salesforce through Data Upload Wizard.
3. Data should consist of Age, Male Mortality, Female Mortality
3. Map the data to correspond fields mentioned in step 1.
4. Setup Complete. You should be able to use ActuarialTable library now.

# Example:
The present value of a lifetime assurance on a person at age 10, with 2 years waiting period.
```
ActuarialLifeTable ATB = new ActuarialLifeTable(0.03,'Male');
ActuarialLifeTable.Ax(10,2);
ActuarialLifeTable ATB = new ActuarialLifeTable(0.03,'Female');
ActuarialLifeTable.Axn(25,1,1);
```

# `ActuarialTable`

| Modifier and type | Method |
|-------------------|--------|
| `static Decimal` | `disc()`| 
| `static Decimal` | `lx(Integer x)`|
| `static Decimal` | `dx(Integer x)`|
| `static Decimal` | `qx(Integer x)`|
| `static Decimal` | `D_x(Integer x)`|
| `static Decimal` | `C_x(Integer x)`|
| `static Decimal` | `N_x(Integer x)`|
| `static Decimal` | `M_x(Integer x)`|
| `static Decimal` | `Ax(integer x, integer f)`|
| `static Decimal` | `Axn(integer x,integer n, integer f)`|
| `static Decimal` | `Exn(integer x, integer n)`|
| `static Decimal` | `AnnDuenx(integer x, integer n, integer k, integer f)`|
| `static Decimal` | `AnnDuex(integer x,integer k, integer f)`|


