function[coupon_income]=agent_coupons_income_computing(agent,bond)

yield = bond.NominalYield;
FaceValue = bond.FaceValue;
coupon = yield*FaceValue;
qty = agent.portfolio.(bond.id);

coupon_income = qty*coupon;

