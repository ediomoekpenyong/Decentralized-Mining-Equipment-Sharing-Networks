# Decentralized Mining Equipment Sharing Network

A comprehensive blockchain-based system for sharing mining equipment among multiple stakeholders, built on the Stacks blockchain using Clarity smart contracts.

## Overview

This system enables miners to share expensive mining equipment through a decentralized network, reducing individual costs and maximizing equipment utilization. The platform handles owner verification, equipment rentals, maintenance coordination, cost sharing, and stakeholder governance.

## Architecture

### Smart Contracts

1. **Equipment Owner Verification** (`equipment-owner-verification.clar`)
    - Validates mining equipment owners
    - Maintains equipment registry
    - Handles owner verification process

2. **Equipment Rental** (`equipment-rental.clar`)
    - Manages equipment rental agreements
    - Handles availability and pricing
    - Tracks active rentals

3. **Maintenance Coordination** (`maintenance-coordination.clar`)
    - Schedules equipment maintenance
    - Coordinates with technicians
    - Tracks maintenance costs and completion

4. **Utilization Optimization** (`utilization-optimization.clar`)
    - Monitors equipment usage metrics
    - Generates optimization recommendations
    - Calculates efficiency scores

5. **Cost Sharing** (`cost-sharing.clar`)
    - Creates cost-sharing pools
    - Manages participant contributions
    - Handles payment settlements

6. **Stakeholder Coordination** (`stakeholder-coordination.clar`)
    - Manages stakeholder registration
    - Handles governance proposals
    - Coordinates voting and decision-making

## Features

### For Equipment Owners
- Verify ownership and register equipment
- List equipment for rental with custom pricing
- Track utilization and maintenance schedules
- Participate in cost-sharing arrangements
- Engage in network governance

### For Renters
- Browse available equipment
- Rent equipment for specified periods
- Share costs with other miners
- Participate in maintenance decisions

### For Technicians
- Register as verified maintenance providers
- Accept maintenance assignments
- Track service history and payments

### For Network Coordinators
- Monitor overall network health
- Optimize equipment distribution
- Facilitate stakeholder coordination
- Manage governance processes

## Getting Started

### Prerequisites
- Stacks blockchain node or access to testnet
- Clarity CLI tools
- Node.js and npm for testing

### Installation

1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd mining-equipment-sharing
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Run tests:
   \`\`\`bash
   npm test
   \`\`\`

### Deployment

Deploy contracts to Stacks testnet:
\`\`\`bash
# Deploy each contract individually
clarinet deploy --testnet contracts/equipment-owner-verification.clar
clarinet deploy --testnet contracts/equipment-rental.clar
clarinet deploy --testnet contracts/maintenance-coordination.clar
clarinet deploy --testnet contracts/utilization-optimization.clar
clarinet deploy --testnet contracts/cost-sharing.clar
clarinet deploy --testnet contracts/stakeholder-coordination.clar
\`\`\`

## Usage Examples

### Register as Equipment Owner
\`\`\`clarity
(contract-call? .equipment-owner-verification verify-owner 'SP1234...)
(contract-call? .equipment-owner-verification register-equipment "ASIC Miner" "S19-12345")
\`\`\`

### List Equipment for Rent
\`\`\`clarity
(contract-call? .equipment-rental list-equipment u1 u100) ;; Equipment ID 1, 100 STX per day
\`\`\`

### Rent Equipment
\`\`\`clarity
(contract-call? .equipment-rental rent-equipment u1 u7) ;; Rent equipment 1 for 7 days
\`\`\`

### Schedule Maintenance
\`\`\`clarity
(contract-call? .maintenance-coordination schedule-maintenance u1 "Routine Service" u1000 u500)
\`\`\`

## Testing

The project includes comprehensive tests using Vitest:

\`\`\`bash
npm test
\`\`\`

Tests cover:
- Contract deployment and initialization
- Equipment registration and verification
- Rental workflows
- Maintenance scheduling
- Cost sharing mechanisms
- Governance processes

## Security Considerations

- All contracts include proper access controls
- Owner verification prevents unauthorized equipment registration
- Rental agreements are enforced through smart contract logic
- Cost sharing uses cryptographic verification
- Governance requires stakeholder consensus

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For questions or support, please open an issue on GitHub or contact the development team.

## Roadmap

- [ ] Integration with IoT sensors for real-time equipment monitoring
- [ ] Advanced analytics and machine learning for optimization
- [ ] Mobile application for stakeholders
- [ ] Integration with additional blockchain networks
- [ ] Enhanced governance mechanisms
- [ ] Automated maintenance scheduling based on usage patterns
