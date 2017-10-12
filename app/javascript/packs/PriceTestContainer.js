import React from 'react';
import ReactTable from 'react-table';
import { TextField } from '@shopify/polaris';

export default class PriceTestContainer extends React.Component {
  constructor(props) {
    super(props);
    this.CreateColumns = this.CreateColumns.bind(this);
    this.SeedColumnData = this.SeedColumnData.bind(this);
    this.CalcPricePointData = this.CalcPricePointData.bind(this);
    this.RoundPriceDigits = this.RoundPriceDigits.bind(this);
    this.CreateItem = this.CreateItem.bind(this);
    this.handleUnitPriceChange = this.handleUnitPriceChange.bind(this);
  }
  handleUnitPriceChange (id, event) {
    this.props.onUnitPriceChange(id, event);
  }
  CreateItem(variant, index) {
    const unitPriceValueHash = this.props.unitPriceValueHash
    return { 
      variant_title: variant.variant_title,
      variant_price: variant.variant_price,
      unit_cost: <TextField 
                  onChange={(event) => this.handleUnitPriceChange(variant.id, event)}
                  key={index}
                  value={unitPriceValueHash[variant.id]}
                 />
    };
  }
  CreateColumns() {
    const price_points = this.props.price_points;
    return {
            columns: this.SeedColumnData(price_points)
           };
  }
  SeedColumnData(price_points) {
    var columns = [];
    for (price_points > 0; price_points--;) {
      columns.unshift(
        { Header: 'Price Test #' + (price_points + 1),
          accessor: 'test_price_' + price_points
        });
    } 
    return columns;
  }
  CalcPricePointData(base) {
    const price_points = this.props.price_points;
    var pp = price_points;
    for (pp > 0; pp--;) {
      $.extend(base, {[ 'test_price_' + pp]: this.RoundPriceDigits(base.variant_price * this.props.price_multipler[pp])});
    }
    return base;
  }
  RoundPriceDigits(price) {
    const end_digits = this.props.end_digits;
    return Math.floor(price) + end_digits;
  }
  render() {
    const data = this.props.product.variants.map(this.CreateItem).map(this.CalcPricePointData);

    return (<ReactTable
              data={data}
              columns={[
              {
                Header: "Base",
                columns: [
                  {
                    Header: "Product Title",
                    accessor: "variant_title"
                  },{
                    Header: "Original Price",
                    accessor: "variant_price"
                  },{
                    Header: "Unit Cost",
                    accessor: "unit_cost"
                  }
                ]
              },this.CreateColumns()
            ]}
            defaultPageSize={5}
            className="-striped -highlight"
            />
    );
  }
}
