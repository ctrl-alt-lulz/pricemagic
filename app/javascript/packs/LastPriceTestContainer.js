import React from 'react'
import ReactDOM from 'react-dom'
import ReactTable from 'react-table'
import PropTypes from 'prop-types'

import { Page, Card, Select, Button, TextField, Stack, FormLayout,
Thumbnail, ResourceList, Pagination, Layout, Checkbox } from '@shopify/polaris';

export default class LastPriceTestContainer extends React.Component {
  constructor(props) {
    super(props);
  }
  render() {
    return (<ReactTable
              data={this.props.analytics_data}
              columns={[
              {
                Header: "Base",
                columns: [
                  {
                    Header: "Product Title",
                    accessor: "z"
                  },{
                    Header: "Price",
                    accessor: "x"
                  },{
                    Header: "Revenue",
                    accessor: "revenue"
                  }, {
                    Header: "Product Views",
                    accessor: "total_variant_views"
                  }, {
                    Header: "Revenue/View",
                    accessor: "rev_per_view"
                  }, {
                    Header: "Profit",
                    accessor: "profit"
                  }, {
                    Header: "Profit/View",
                    accessor: "profit_per_view"
                  }
                ]
              }
            ]}
            defaultPageSize={5}
            className="-striped -highlight"
            />
    );
  }
}
