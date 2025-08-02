import { QueryInterface, DataTypes } from "sequelize";

module.exports = {
  up: (queryInterface: QueryInterface) => {
    return queryInterface.addColumn("Webhooks", "company_id", {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 1
    });
  },

  down: (queryInterface: QueryInterface) => {
    return queryInterface.removeColumn("Webhooks", "company_id");
  }
}; 