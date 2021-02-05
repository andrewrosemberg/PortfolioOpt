"""
Betina Robust Sampled based Formulation

Further information:
  - Fernandes, B., Street, A., ValladA˜ £o, D., e Fernandes, C. (2016). An adaptive robust portfolio optimization model with loss constraints based on data-driven polyhedral uncertainty sets. European Journal of Operational Research, 255(3):961 – 970. ISSN 0377-2217. URL.

"""
struct RobustBetina <: AbstractSampleBased
    sampled_returns::Array{Float64,2}
    number_of_assets::Int
    number_of_samples::Int
end

function RobustBetina(;
    sampled_returns::Array{Float64,2}
)
    number_of_samples, number_of_assets = size(sampled_returns)

    return RobustBetina(
        sampled_returns, number_of_assets, number_of_samples
    )
end

function _portfolio_return_latex_RobustBetina_dual()
    return """
        ```math
        \\max_{\\theta} \\quad  \\theta \\\\
        s.t.  \\quad \\theta \\leq r_s ' w \\quad \\forall s = 1:\\mathcal{S} \\\\
        ```
        """
end

"""
    portfolio_return!(model::JuMP.Model, w, formulation::RobustBetina)

Returns worst case return in Betina's uncertainty set, defined by the following dual problem: 

$(_portfolio_return_latex_RobustBetina_dual())
"""
function portfolio_return!(model::JuMP.Model, w, formulation::RobustBetina)
    # auxilary variables
    θ = @variable(model, θ)
    # convex hull
    @constraint(model, sum(formulation.sampled_returns * w , dims=2) .>= θ)

    return θ
end