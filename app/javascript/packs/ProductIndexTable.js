import React from 'react'
import ReactDOM from 'react-dom'
import ReactTable from 'react-table'
import PropTypes from 'prop-types'
import { Checkbox } from '@shopify/polaris';

export default class ProductIndexTable extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
     selected: {},
     selectAll: 0,
     products: this.props.products
    }
    //this.handleChange = this.handleChange.bind(this)
    this.toggleRow = this.toggleRow.bind(this);
  }
  // handleChange(event) {
  //   console.log('test')
  //   console.log(this.state.rowInfo)
  //   console.log('test')
  // }
	toggleRow(title) {
		const newSelected = Object.assign({}, this.state.selected);
		newSelected[title] = !this.state.selected[title];
		this.setState({
			selected: newSelected,
			selectAll: 2
		});
	}
	toggleSelectAll() {
		let newSelected = {};
		if (this.state.selectAll === 0) {
			this.state.products.forEach(x => {
				newSelected[x.title] = true;
			});
		}
		this.setState({
			selected: newSelected,
			selectAll: this.state.selectAll === 0 ? 1 : 0
		});
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
            getTdProps={(state, rowInfo, column, instance) => {
              return {
                onClick: (e, handleOriginal) => {
                  // console.log('A Td Element was clicked!')
                  // console.log('it produced this event:', e)
                  // console.log('It was in this column:', column)
                   console.log('It was in this row:', rowInfo.original.title.props.children)
                  // console.log('It was in this table instance:', instance)
               
                  // IMPORTANT! React-Table uses onClick internally to trigger
                  // events like expanding SubComponents and pivots.
                  // By default a custom 'onClick' handler will override this functionality.
                  // If you want to fire the original onClick handler, call the
                  // 'handleOriginal' function.
                  if (handleOriginal) {
                    handleOriginal()
                  }
                }
              }
            }}
            columns={[
            {
              Header: "Base",
              columns: [
                // {
                //   Header: <Checkbox />,
                //   maxWidth: 50,
                //   Cell: rowInfo => (<Checkbox key={rowInfo.index} onChange={this.handleChange} />)
                // },
          	    {
      						id: "checkbox",
      						accessor: "",
      						Cell: ( rowInfo ) => {
      							return (
      								<Checkbox
      									type="checkbox"
      									className="checkbox"
      								  checked={this.state.selected[rowInfo.original.title.props.children] === true}
      									onChange={() => this.toggleRow(rowInfo.original.title.props.children)}
      								/>
      							);
      						},
      						Header: title => {
      							return (
      								<Checkbox
      									type="checkbox"
      									className="checkbox"
      									checked={this.state.selectAll === 1}
      									ref={input => {
      										if (input) {
      											input.indeterminate = this.state.selectAll === 2;
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
