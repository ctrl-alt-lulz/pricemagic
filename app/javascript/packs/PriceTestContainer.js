import React from 'react'
import ReactDOM from 'react-dom'
import ReactTable from 'react-table'
import PropTypes from 'prop-types'

import { Page, Card, Select, Button, TextField, Stack, FormLayout,
Thumbnail, ResourceList, Pagination, Layout, Checkbox } from '@shopify/polaris';

export default class PriceTestContainer extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
    };
  }
  render() {
    function CreateItem(variant) {
      return { 
        variant_title: variant.variant_title,
        variant_price: variant.variant_price
      }
    }
    function CreateColumns() {
      return {
                columns: SeedColumnData(3)
              }
    }
    function SeedColumnData(num_of_cols) {
      var columns = [];
      for (num_of_cols > 0; num_of_cols--;) {
        columns.push({Header: 'Price Test #' + num_of_cols});
      } 
      return columns
    }
    const data = this.props.price_test.variants.map(CreateItem)
    console.log(this.props.price_test)
    console.log(this.props.price_test.variants)
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
                    Header: "Price",
                    accessor: "variant_price"
                  }
                ]
              },CreateColumns()
            ]}
            defaultPageSize={10}
            className="-striped -highlight"
            />
    );
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('price-test-container')
  const data= JSON.parse(node.getAttribute('data'))
ReactDOM.render(<PriceTestContainer {...data}/>, node)
})
