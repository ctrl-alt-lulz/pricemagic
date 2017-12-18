import React from 'react';
import { PureComponent, PropTypes }from 'react'
import ReactTable from 'react-table';
import { TextField } from '@shopify/polaris';

class TextFieldWrapper extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      value: this.props.variantValue[this.props.variantId] || '',
    }
  }
  updateValue(value){
    this.setState({
      value: value,
    });
  }
  handleUnitPriceChange() {
    this.props.onUnitPriceChange(this.props.variantId, this.state.value);
  }
  render(){
    return (
      <TextField
        type="number"
        id={this.props.variantId}
        key={this.props.variantId}
        onChange={this.updateValue.bind(this)}
        onBlur={this.handleUnitPriceChange.bind(this)}
        value={this.state.value}
      />
    );
  }
}

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
  CreateItem(variant) {
    const unitPriceValueHash = this.props.unitPriceValueHash
    return { 
      variant_title: variant.variant_title,
      variant_price: variant.variant_price,
      unit_cost: <TextFieldWrapper 
                  variantId={variant.id}
                  variantValue={unitPriceValueHash}
                  onUnitPriceChange={this.handleUnitPriceChange}
                />
    };
  }

  CreateColumns() {
    const price_points = this.props.price_points;
    return { columns: this.SeedColumnData(price_points) };
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

    function DisplayBasedOnPriceTestStatus(props) {
      return(<ReactTable
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
              },props.CreateColumns
            ]}
            defaultPageSize={5}
            className="-striped -highlight"
            />);
    }
    
    return (<DisplayBasedOnPriceTestStatus CreateColumns={this.CreateColumns()}/>);
  }
}
