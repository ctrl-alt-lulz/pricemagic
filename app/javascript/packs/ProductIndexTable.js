import React from 'react'
import ReactTable from 'react-table'
import { Checkbox } from '@shopify/polaris';

export default class ProductIndexTable extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
    }
    this.toggleRow = this.toggleRow.bind(this);
    this.toggleSelectAll = this.toggleSelectAll.bind(this);
  }
	toggleRow(title) {
	  this.props.onToggleRow(title)
	}
	toggleSelectAll() {
	  this.props.onToggleSelectAll()
	}

  render() {
    function CreateItem(product) {
      return { 
        title: <a href={'/products/' + product.id} >{product.title}</a>,
        price_test_status: product.has_active_price_test,
        price_test_completion_percentage: product.price_test_completion_percentage
      }
    }
  return (<ReactTable
            data={this.props.products.map(CreateItem)}
            columns={[
            {
              Header: "Base",
              columns: [
          	    {
      						id: "checkbox",
      						accessor: "",
      						Cell: ( rowInfo ) => {
      							return (
      								<Checkbox
      									type="checkbox"
      									className="checkbox"
      								  checked={this.props.selected[rowInfo.original.title.props.children] === true}
      									onChange={() => this.toggleRow(rowInfo.original.title.props.children)}
      								/>
      							);
      						},
      						Header: title => {
      							return (
      								<Checkbox
      									type="checkbox"
      									className="checkbox"
      									checked={this.props.selectAll === 1}
      									ref={input => {
      										if (input) {
      											input.indeterminate = this.props.selectAll === 2;
      										}
      									}}
      									onChange={() => this.toggleSelectAll()}
      								/>
      							);
      						},
      						sortable: false,
      						width: 45
      					},                
                {
                  Header: "Product Title",
                  accessor: "title",
                  maxWidth: 400
                }, {
                  Header: "Price Test Status",
                  accessor: "price_test_status",
                  maxWidth: 200
                }, {
                  Header: "Price Test Completion Percentage",
                  accessor: "price_test_completion_percentage",
                  Cell: row => (
                    <div
                      style={{
                        width: '100%',
                        height: '100%',
                        backgroundColor: '#dadada',
                        borderRadius: '2px'
                      }}
                    >
                    <div
                      style={{
                        width: `${row.value}%`,
                        height: '100%',
                        backgroundColor: row.value > 66 ? '#85cc00'
                          : row.value > 33 ? '#ffbf00'
                          : '#ff2e00',
                        borderRadius: '2px',
                        transition: 'all .2s ease-out'
                      }}
                    />
                    </div>
                  )
                }
              ]
            }
            ]}
            defaultPageSize={10}
            className="-striped -highlight"
          />
  );}
}
