import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import {Page, Card, Select, Button, TextField, Stack,
Thumbnail, ResourceList, Pagination, Layout} from '@shopify/polaris';

class ProductIndexPage extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      term: '',
      collection_id: null,
      products: this.props.products,
    };
    this.handleTermChange = this.handleTermChange.bind(this);
    this.handleCollectionChange = this.handleCollectionChange.bind(this);
    this.col_hash = this.props.collections.reduce(function ( total, current ) {
        total[ current.title ] = current.id;
        return total;
      }, {});
  }

  handleTermChange(event) {
    this.setState({term: event}, () => {
      this.searchProducts()
    });
  }
  handleCollectionChange(event) {
    console.log('Handle Collection')
    console.log(this.col_hash['necklace'])
    console.log(event)
    this.setState({
      collection_id: this.col_hash[event],
      collection: event
    }, () => {
      this.searchProducts()
    });
  }
  render() {
    function CreateItem(product) {
      return { 
        url: '/products/' + product.id, 
        attributeOne: product.title,
        attributeTwo: product.variants[0].variant_price,
        attributeThree: '5 prices from $8.99 to $13.99',
        media: <Thumbnail
                  source={product.main_image_src}
                  alt={product.title}
                  size="small"
                />
      }
    }
    function CollectionTitles(collection) {
      return collection.title
    }
    // function CollectionHash(){
    //   var obj = this.props.collections.reduce(function ( total, current ) {
    //     total[ current.title ] = current.id;
    //     return total;
    //   }, {});
    //   return obj;
    // }
    return (
      <Layout>
        <Layout.Section>
          <Card title="Online store dashboard" actions={[{content: 'Edit'}]} sectioned>
            <Card.Section>
              <Stack>
                <TextField 
                  value={this.state.term}
                  label="Keyword Search"
                  placeholder="Enter Term"
                  onChange={this.handleTermChange}
                />
                <Select
                  value= {this.state.collection}
                  label="Collection"
                  options={ this.props.collections.map(CollectionTitles) }
                  placeholder="Select"
                  onChange={this.handleCollectionChange}
                  //onChange={this.valueUpdater('collection')}
                  //onChange={this.searchProducts('collection')}
                />
              </Stack>
            </Card.Section>
            <Card.Section>
                <ResourceList
                  items={
                      this.state.products.map(CreateItem)
                  }
                  renderItem={(item, index) => {
                    return <ResourceList.Item key={index} {...item} className='Polaris-Card' />;
                  }}
                />
            </Card.Section>
          </Card>
        </Layout.Section>
      </Layout>
    );  
  }
searchProducts() {
  console.log('/products/' + "?term=" + this.state.term + "&collection=" + this.state.collection_id)
  $.ajax( {
    url: '/products/' + "?term=" + this.state.term + "&collection=" + this.state.collection_id,
    dataType: 'json',
    success: function(data) {
    this.setState({ products: data });
    }.bind(this),
    error: function(data) {
    }.bind(this)
   });
}
  


  // searchProducts(field) {
  //   console.log('In queryProducts');
  //   console.log(this);
  //   console.log(this.state.value)
    
  //   return(value) => {
  //     if (value){
  //       $.ajax( {
  //         url: this.props.products_path + "?term=" + this.state.term, //+ "&collection=" + this.state.collection,
  //   	    dataType: 'json',
  //   	    success: function(data) {
  //         this.setState({ products: data });
  //   	    }.bind(this),
  //   	    error: function(data) {
  //   	    }.bind(this)
  //   	   });
  //     }
  //   }
  // }
}
  
document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('hello-react')
  const data = JSON.parse(node.getAttribute('data'))
ReactDOM.render(<ProductIndexPage {...data}/>, node)
})

    
    