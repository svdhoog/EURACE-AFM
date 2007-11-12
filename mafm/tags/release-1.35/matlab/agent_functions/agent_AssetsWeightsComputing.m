function[agent]=agent_AssetsWeightsComputing(agent)

global Parameters

t = Parameters.current_day;

% Each agent updates its portofolio weights only when it updates beliefs
if agent.beliefs_update(t)==1
    if strcmp(agent.PortfolioAllocationRule.class,'MPT')
        agent = agent_AssetsWeightsComputing_MPT(agent);
    elseif strcmp(agent.PortfolioAllocationRule.class,'PT')
        if ~strcmp(agent.class,'household')
            error('The PT portfolio allocation rule is feasible only for households')
        end
        agent = household_AssetsWeightsComputing_PT(agent);
    elseif strcmp(agent.PortfolioAllocationRule.class,'Rnd')
        agent = agent_AssetsWeightsComputing_Rnd(agent);
    else
        error('The portfolio allocation rule is unknown')
    end
end