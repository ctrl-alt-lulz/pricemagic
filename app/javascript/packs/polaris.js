import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import {Page, Card, Button, Thumbnail, ResourceList, Pagination} from '@shopify/polaris';

class Hello extends React.Component {
  render() {
    function CreateItem(product) {
      return { 
              url: '#', 
              attributeOne: product.title,
              attributeTwo: product.first_variant_price,
              media: <Thumbnail
                        source={product.main_image_src}
                        alt={product.title}
                        size="large"
                      />
             }
      }
    return (
      <ResourceList
        items={
            this.props.products.map(CreateItem)
        }
        renderItem={(item, index) => {
          return <ResourceList.Item key={index} {...item} />;
        }}
      />
    );
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('hello-react')
  const data = JSON.parse(node.getAttribute('data'))
ReactDOM.render(<Hello {...data}/>, node)
})

    
    